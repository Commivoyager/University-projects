using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

using RabbitMQ.Client;
using System.Text;
using System;
using System.Threading.Tasks;



namespace CheckersServer
{
    internal class Server
    {
        public const string rabbitName = "rabbitmq";
        public const string gameServName = "game-server";
        public static int brockerPort = 5672;
        public static int hostPort = 5555;
        const int playersNum = 2;
        const int bufSize = 512;

        public const int codeM = 0;
        public const int priorM = 1;
        public const int col1M = 2;
        public const int row1M = 3;
        public const int col2M = 4;
        public const int row2M = 5;

        private const int movDataNum = 6;

        public const int isLastMotion = 7;

        public const int userIdM = 8; 

        public const int ErrCode = 0;
        public const int ContinueCode = 100;
        public const int OKCode = 200;
        public const int CreatedCode = 201;
        public const int GameOverCode = 222;
        public const int QuitCode = 221;

        public const int AuthCode = 230;
        public const int RegCode = 231;
        public const int AuthSuccess = 232; 
        public const int AuthFailed = 233; 

        public const int GetGamesDataCode = 235;

        public int userId1 = 1;
        public int userId2 = 2;

        IPAddress hostIPAddr;
        IPEndPoint endPoint;
        TcpListener server;
        TcpClient player1, player2;
        NetworkStream stream1, stream2;
        NetworkStream[] streams;
        Random random = new Random();
        byte[] buffer;

        public RabbitMQ.Client.IChannel brockerChnl;
        public const string exchangeName = "checkers";

        public const string db_add_key = "db_add_data";
        public const string db_sample_key = "db_sample_data";
        public const string db_update_key = "db_update_data";
        public const string db_remove_key = "db_remove_data";

        public const string move_service_key = "move_service";
        public const string game_inst_inf_key = "game_inst_inf";
        public const string ident_service_key = "ident_service";

        public const string game_server_key = "game_server";
        public const string log_key = "log";


        public static int GameId = 0;

        // Данные авторизации
        public bool identActDone = false;
        public bool isAuthSuccess = false;
        public string authAnsw = "";

        public bool gamesDataReceived = false;

        public string allGamesData = "";

        byte[] forLog = null;


        string logFPath = Path.Combine(Directory.GetCurrentDirectory(), "GameServer.log");

        public static readonly object fileLock = new object();


        public Server(RabbitMQ.Client.IChannel brockerChnl)
        {
            this.brockerChnl = brockerChnl;
            try
            {
                IPAddress[] addresses = Dns.GetHostAddresses(gameServName);

                endPoint = new IPEndPoint(addresses[0], hostPort);
                server = new TcpListener(endPoint);
                server.Start();
                buffer = new byte[bufSize];
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }

        }

        public void ConnectPlayers()
        {
            brockerChnl.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Server started"));
            logFunc("Server started");

            player1 = server.AcceptTcpClient();
            stream1 = player1.GetStream();
            brockerChnl.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("First player connected"));
            logFunc("First player connected");

            player2 = server.AcceptTcpClient();
            stream2 = player2.GetStream();
            brockerChnl.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Second player connected"));
            logFunc("Second player connected");

            SetUserStreams();
        }

        private void SetUserStreams()
        {
            streams = new NetworkStream[playersNum];

            streams[0] = stream1;
            streams[1] = stream2;  
        }

        //Authorization
        public void AuthorizeUsers()
        {
            byte succAuth = 1;
            byte faileAuth = 0;
            for (int i = 0; i < playersNum;)
            {
                Array.Clear(buffer, 0, buffer.Length);
                streams[i].Read(buffer, 0, bufSize);

                brockerChnl.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes(stringOutp("Took from client authentification data")));


                byte[] takenData = new byte[buffer.Length-1];
                Array.Copy(buffer, 1, takenData, 0, takenData.Length);
                byte[] senderName = Encoding.UTF8.GetBytes($"{ident_service_key}");
                byte[] body = new byte[takenData.Length+senderName.Length];
                Array.Copy(senderName, 0, body, 0, senderName.Length);
                Array.Copy(takenData, 0, body, senderName.Length, takenData.Length);
                if (buffer[codeM] == RegCode)
                {
                    brockerChnl.BasicPublishAsync(exchange: exchangeName, routingKey: db_add_key/* string.Empty*/, body: body);
                }
                else if (buffer[codeM] == AuthCode)
                {
                    brockerChnl.BasicPublishAsync(exchange: exchangeName, routingKey: db_sample_key/* string.Empty*/, body: body);

                }

                while (!identActDone)
                {
                    System.Threading.Thread.Sleep(100);
                }
                identActDone = false;

                byte[] answ = new byte[512];
                byte[] answStr = Encoding.UTF8.GetBytes(authAnsw);
                Array.Copy(answStr, 0, answ, 1, answStr.Length);
                if (isAuthSuccess)
                {
                    answ[0] = AuthSuccess;
                    string[] answData = authAnsw.Split(',');
                    int userId;
                    if (!int.TryParse(answData[2],out userId))
                    {
                        userId = 0;
                    }
                    if(i % 2 == 0)
                    {
                        userId1 = userId;
                    }
                    else
                    {
                        userId2 = userId;
                    }
                }
                else
                {
                    answ[0] = AuthFailed;
                }

                streams[i].Write(answ, 0, answ.Length);
                Array.Clear(answ, 0, answ.Length);
                if (isAuthSuccess)
                {
                    i++;
                    isAuthSuccess = false;
                }
            }
        }

        public void startCommunication()
        {
            int startedGameCount = 0;
            while(startedGameCount < 3)
            {
                for (int i = startedGameCount; i < playersNum; i++)
                {
                    if (i == startedGameCount - 1) continue;
                    Array.Clear(buffer, 0, buffer.Length);
                    streams[i].Read(buffer, 0, bufSize);
                    brockerChnl.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes(stringOutp("Took from client")));
                    logFunc(stringOutp("Took from client"));
                    if (buffer[codeM] == CreatedCode)
                    {
                        buffer[priorM] = (byte)(i + 1);
                        streams[i].Write(buffer, 0, bufSize);
                        brockerChnl.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes(stringOutp("Sent to client")));
                        logFunc(stringOutp("Sent to client"));
                        startedGameCount += i + 1;
                        if (i == 3) break;
                    }
                    else if (buffer[codeM] == GetGamesDataCode)
                    {
                        allGamesData = "";
                        int id = userId2;
                        if (i % 2 == 0)
                        {
                            id = userId1;
                        }
                        string mess = $"{game_server_key}," +id.ToString() + ",";
                        byte[] body = Encoding.UTF8.GetBytes(mess);
                        brockerChnl.BasicPublishAsync(exchange: exchangeName, routingKey: db_sample_key, body: body);

                        while (!gamesDataReceived)
                        {
                            System.Threading.Thread.Sleep(100);
                        }
                        gamesDataReceived = false;
                        streams[i].Write(Encoding.UTF8.GetBytes(allGamesData));
                    }
                }
            }
            string message = $"{game_inst_inf_key},{userId1},{userId2},{DateTime.Now.AddHours(3)}";
            var gameInfBody = Encoding.UTF8.GetBytes(message);

            brockerChnl.BasicPublishAsync(exchange: exchangeName, routingKey: db_add_key, body: gameInfBody);
        }

        public void serverCommunication()
        {
            string message;
            bool serverCycle = true;
            while (serverCycle)
            {
                for (int i = 0; i < playersNum; i++)
                {
                    byte code;
                    int newInd = (i + 1) % 2;
                    try
                    {
                        Array.Clear(buffer, 0, buffer.Length);
                        streams[i].Read(buffer, 0, bufSize);
                    }
                    catch (Exception e)
                    {
                        brockerChnl.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Error when user data reading"));
                        logFunc("Error when user data reading");

                        try
                        {
                            buffer[codeM] = QuitCode;
                            streams[newInd].Write(buffer, 0, bufSize);
                        }
                        catch
                        { }
                        if (streams[i] != null)
                        {
                            streams[i].Close();
                            streams[i].Dispose();
                            streams[i] = null;
                        }
                        if (streams[newInd] != null)
                        {
                            streams[newInd].Close();
                            streams[newInd].Dispose();
                            streams[newInd] = null;
                        }
                        if (player1 != null)
                        {
                            player1.Close();
                            player1.Dispose();
                            player1 = null;
                        }
                        if (player2 != null)
                        {
                            player2.Close();
                            player2.Dispose();
                            player2 = null;
                        }
                        serverCycle = false;
                        Console.WriteLine("Disconnect");
                    }
                    brockerChnl.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes(stringOutp("Took from client" + buffer[priorM].ToString())));
                    logFunc(stringOutp("Took from client" + buffer[priorM].ToString()));


                    if (buffer[0] == OKCode || buffer[0] == GameOverCode)
                    {
                        message = $"{move_service_key}";
                        for (int j = 0; j < movDataNum; j++)
                        {
                            if(j == priorM)
                            {
                                message = $"{message},{buffer[userIdM]}";
                            }
                            else
                            {
                                message = $"{message},{buffer[j]}";
                            }
                        }
                        message = $"{message},{GameId}";

                        var body1 = Encoding.UTF8.GetBytes(message);
                        brockerChnl.BasicPublishAsync(exchange: exchangeName, routingKey: db_add_key /* string.Empty*/, body: body1);

                        if (buffer[0] == GameOverCode)
                        {
                            message = $"{game_inst_inf_key},{GameId},{DateTime.Now.AddHours(3)},{buffer[userIdM]},0,";
                            var body2 = Encoding.UTF8.GetBytes(message);
                            brockerChnl.BasicPublishAsync(exchange: exchangeName, routingKey: db_update_key, body: body2);
                        }

                    }
                    else if (buffer[0]==QuitCode){
                        message = $"{game_inst_inf_key},{GameId},{DateTime.Now.AddHours(3)},0,1,";
                        var body1 = Encoding.UTF8.GetBytes(message);
                        brockerChnl.BasicPublishAsync(exchange: exchangeName, routingKey: db_update_key, body: body1);
                    }

                    buffer[priorM] = (byte)(newInd + 1);
                    code = buffer[codeM];
                    try
                    {
                        streams[newInd].Write(buffer, 0, bufSize);
                    }
                    catch (Exception e)
                    {
                        brockerChnl.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Error when user data sending"));
                        logFunc(stringOutp("Error when user data sending"));

                        try
                        {
                            buffer[codeM] = QuitCode;
                            streams[i].Write(buffer, 0, bufSize);
                        }
                        catch
                        { }
                        if (streams[i] != null)
                        {
                            streams[i].Close();
                            streams[i].Dispose();
                            streams[i] = null;
                        }
                        if (streams[newInd] != null)
                        {
                            streams[newInd].Close();
                            streams[newInd].Dispose();
                            streams[newInd] = null;
                        }
                        if (player1 != null)
                        {
                            player1.Close();
                            player1.Dispose();
                            player1 = null;
                        }
                        if (player2 != null)
                        {
                            player2.Close();
                            player2.Dispose();
                            player2 = null;
                        }
                        serverCycle = false;
                        brockerChnl.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Disconnect"));
                        logFunc("Disconnect");
                    }
                    brockerChnl.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes(stringOutp("Sent to client" + buffer[priorM].ToString())));
                    logFunc(stringOutp("Sent to client" + buffer[priorM].ToString()));
                    if (code != OKCode && code != ContinueCode)
                    {
                        serverCycle = false;
                        break;
                    }
                }
            }
        }

        private string stringOutp(string comment)
        {
            string outp = "";
            outp += comment;
            for (int i = 0; i < bufSize; i++)
            {
                outp += buffer[i].ToString() + "; ";
            }
            outp += Environment.NewLine + Environment.NewLine;
            return outp;
        }

        private void logFunc(string str)
        {

            lock (fileLock)
            {
                using (var writer = new StreamWriter(logFPath, append: true))
                {
                    writer.WriteLine(str + "\n");
                    writer.Flush();

                }
            }
        }
    }
}
