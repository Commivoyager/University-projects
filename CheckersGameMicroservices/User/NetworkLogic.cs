using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace Checkers
{
    public class NetworkLogic
    {
        bool correctWork; 
        string message;

        public static string autoAddr = "127.0.0.1";
        public static int autoPort = 5555;
        const int maxPortNum = 65536;
        public const int bufSize = 512;
        
        IPAddress connectionAddr;
        int connectionPort;
        IPEndPoint endPoint;
        NetworkStream stream;
        Socket socket = null;

        byte[] buffer;

        public NetworkLogic(string IP, int port) 
        {
            try
            {
                connectionAddr = IPAddress.Parse(IP);
                connectionPort = port;
                endPoint = new IPEndPoint(connectionAddr, connectionPort);
               
                socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
                socket.Connect(endPoint);
                stream = new NetworkStream(socket);

            }
            catch (FormatException)
            {
                throw new ArgumentException("Возникла ошибка! Некорректный IP");
            }
            catch (ArgumentOutOfRangeException)
            {
                    throw new ArgumentException("Возникла ошибка! Номер порта должен быть неотрицательным числом, меньшим " + maxPortNum.ToString());
            }
            catch (SocketException)
            {
                throw new ArgumentException("Возникла ошибка! Не удалось подключиться к серверу");
            }
            catch(Exception e)
            {
                throw new ArgumentException("Возникла ошибка! " + e.ToString());
            }
            buffer = new byte[bufSize];
        }

        public (byte[], int) getServerMess()
        {
            int size = stream.Read(buffer, 0, bufSize);
            return (buffer, size);
        }

        public void sendClientMess(byte[] buf)
        {
            stream.Write(buf, 0, buf.Length);
        }

        public void disconnect()
        {
            if(stream != null)
            {
                stream.Close();
                stream.Dispose();
                stream = null;
            }
            if(socket != null)
            {
                socket.Close();
                socket.Dispose();
                socket = null;
            }
        }
    }
}
