using Godot;
using System;
using System.Text;
using System.Linq;

public class Simulator3D : Spatial
{
	[Export]
	private string WsSocketUrl = "ws://127.0.0.1:8080/ofs";

	private WebSocketClient webSocketClient;
	public bool ClientConnected { get; private set; } = false;

	public float CurrentTime { get; private set; } = 0.0f;
	public bool IsPlaying { get; private set; } = false;
	public float PlaybackSpeed { get; private set; } = 1.0f;

	private Label label;
	private MeshInstance indicatorMesh;
	private Funscript[] scripts = new Funscript[(int)ScriptType.TypeCount];

	public override void _Ready()
	{
		var args = OS.GetCmdlineArgs();
		if(args.Length > 0)
		{
			WsSocketUrl = args[0];
		}

		label = GetNode<Label>("UI/Label");
		indicatorMesh = GetNode<MeshInstance>("Space/Indicator");

		webSocketClient = new WebSocketClient();
		webSocketClient.Connect("connection_closed", this, nameof(connectionClosed));
		webSocketClient.Connect("connection_error", this, nameof(connectionError));
		webSocketClient.Connect("data_received", this, nameof(dataReceived));
		webSocketClient.Connect("server_close_request", this, nameof(serverCloseRequest));
		webSocketClient.Connect("connection_established", this, nameof(connectionEstablished));

		var error = webSocketClient.ConnectToUrl(WsSocketUrl, new string[]{"ofs-api.json"});
		GD.Print("Connecting to ", WsSocketUrl, " Error: ", error);
		label.Text = $"Trying to connect to {WsSocketUrl}";
	}

	// public override void _Input(InputEvent ev)
	// {
	//     if(ev is InputEventKey key)
	//     {
	//         if(key.Pressed && !key.Echo && key.Scancode == 'P')
	//         {
	//             var playCommand = new Godot.Collections.Dictionary();
	//             playCommand["type"] = "command";
	//             playCommand["name"] = "change_play";
	//             playCommand["data"] = new Godot.Collections.Dictionary()
	//             {
	//                 { "playing", !IsPlaying }
	//             };
	//             var jsonMsg = JSON.Print(playCommand);
	//             GD.Print(jsonMsg);
	//             webSocketClient.GetPeer(1).SetWriteMode(WebSocketPeer.WriteMode.Text);
	//             webSocketClient.GetPeer(1).PutPacket(Encoding.UTF8.GetBytes(jsonMsg));
	//         }
	//     }
	// }

	private static ScriptType? getScriptType(string name)
	{
		var elements = name.Split('.');
		if (elements.Length == 1 || elements.Last().ToLower().Equals("l0"))
			return ScriptType.MainStroke;
		if (elements.Last().ToLower().Contains("raw"))
			return ScriptType.MainStroke;

		var last = elements.Last().ToLower();
		if (last.Contains("alpha") || last.Contains("e0"))
			return ScriptType.Alpha;
		else if (last.Contains("beta") || last.Contains("e1"))
			return ScriptType.Beta;
		else if (last.Contains("gamma") || last.Contains("e2"))
			return ScriptType.Gamma;

		return null;
	}

	private void addOrUpdate(Godot.Collections.Dictionary changeEvent)
	{
		var name = changeEvent["name"] as string;
		var type = getScriptType(name);
		if(type.HasValue)
		{
			var script = scripts[(int)type.Value];
			if(script == null)
				scripts[(int)type.Value] = new Funscript(changeEvent);
			else 
				script.UpdateFromEvent(changeEvent);
		}
		else 
		{
			GD.PrintErr("Failed to determine script type for ", name);
		}
	}

	private void removeScript(string name)
	{
		var script = scripts
			.Select((x, idx) => new Tuple<Funscript, int>(x, idx))
			.FirstOrDefault(x => x.Item1 != null && x.Item1.Name == name);
		if(script != null)
			scripts[script.Item2] = null;
	}
	
	private void connectionError()
	{
		ClientConnected = false;
		label.Text = "Connection error";
		
		scripts = new Funscript[(int)ScriptType.TypeCount];
		var error = webSocketClient.ConnectToUrl(WsSocketUrl, new string[]{"ofs-api.json"});
		GD.Print("Connecting to ", WsSocketUrl, " Error: ", error);
	}

	private void connectionClosed(bool wasClean)
	{
		ClientConnected = false;
		label.Text = "Connection closed";

		scripts = new Funscript[(int)ScriptType.TypeCount];
		var error = webSocketClient.ConnectToUrl(WsSocketUrl, new string[]{"ofs-api.json"});
		GD.Print("Connecting to ", WsSocketUrl, " Error: ", error);
	}

	private void connectionEstablished(string protocol)
	{
		ClientConnected = true;
		GD.Print("Connection established.");
		label.Text = "";
	}

	private void serverCloseRequest(int code, string reason)
	{
		GD.Print("!!!!!!!UNHANDLED SERVER CLOSE REQUEST!!!!!!!");
		throw new NotImplementedException();
	}

	private void dataReceived()
	{
		var packet = webSocketClient.GetPeer(1).GetPacket();
		string response = Encoding.UTF8.GetString(packet);

		var json = JSON.Parse(response);
		if(json.Error == Error.Ok)
		{
			var obj = json.Result as Godot.Collections.Dictionary;
			if(!obj.Contains("type")) return;

			string type = obj["type"] as string;
			if(type == "event")
			{
				var data = obj["data"] as Godot.Collections.Dictionary;
				switch(obj["name"] as string)
				{
					case "time_change":
						CurrentTime = data["time"] as float? ?? 0.0f;
						break;
					case "project_change":
						scripts = new Funscript[(int)ScriptType.TypeCount];
						break;
					case "play_change":
						IsPlaying = data["playing"] as bool? ?? false;
						break;
					case "playbackspeed_change":
						PlaybackSpeed = data["speed"] as float? ?? 1.0f;
						break;
					case "funscript_change":
						GD.Print("Funscript update: ", data["name"]);
						addOrUpdate(data);
						break;
					case "funscript_remove":
						removeScript(data["name"] as string);
						break;
				}
			}

		}        
	}

	public override void _Process(float delta)
	{
		webSocketClient.Poll();

		if(IsPlaying) {
			// This is supposed to smooth out the timer
			// in between time updates received via the websocket
			CurrentTime += delta * PlaybackSpeed;
		}

		float mainStroke = 0.5f;
		float alpha = 0.5f;
		float beta  = 0.5f;
		float gamma = 0.5f;

		if(scripts[(int)ScriptType.MainStroke] != null)
		{
			var script = scripts[(int)ScriptType.MainStroke];
			mainStroke = script.GetPositionAt(CurrentTime);
		}

		if(scripts[(int)ScriptType.Alpha] != null)
		{
			var script = scripts[(int)ScriptType.Alpha];
			alpha = script.GetPositionAt(CurrentTime);
		}

		if(scripts[(int)ScriptType.Beta] != null)
		{
			var script = scripts[(int)ScriptType.Beta];
			beta  = script.GetPositionAt(CurrentTime);
		}

		if(scripts[(int)ScriptType.Gamma] != null)
		{
			var script = scripts[(int)ScriptType.Gamma];
			gamma = script.GetPositionAt(CurrentTime);
		}

		indicatorMesh.Translation = new Vector3(
			Mathf.Lerp(0.5f, -0.5f, beta),
			Mathf.Lerp(-0.5f, 0.5f, alpha),
			Mathf.Lerp(0.5f, -0.5f, gamma)
		);
	}
}
