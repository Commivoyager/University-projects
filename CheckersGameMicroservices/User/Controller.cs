using System;
using System.Collections.Generic;
using System.Diagnostics.Eventing.Reader;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;
using System.Security.Cryptography;

namespace Checkers
{
    public class Controller
    {
        // Константы, определяющие индексы в массиве, присылаемом
        // в качестве пакета
        public const int codeM = 0;
        public const int priorM = 1;
        public const int col1M = 2;
        public const int row1M = 3;
        public const int col2M = 4;
        public const int row2M = 5;
        public const int isLastMotion = 7;
        public const int userIdM = 8;
        
        // Коды для организации передачи данных и начала/окончания связи
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

        public MenuForm menuF;
        public GameForm gameF;
        public AuthForm authF;
        public UserPage userF;
        public NetworkLogic netwL;
        GameLogic game;
        public bool netwCreated;
        public int bufSize = NetworkLogic.bufSize;
        byte[] updateInf;
        int infSize;

        int indXMax;
        int indYMax;

        bool GameFinished = false;

        int userId = 0;

        public string userLogin = "";

        public Controller()
        {
            menuF = new MenuForm(this);
            gameF = new GameForm(this);
            authF = new AuthForm(this);
            userF = new UserPage(this);

            netwL = null;
            netwCreated = false;
            indXMax = GameLogic.mapSize - 1;
            indYMax = GameLogic.mapSize - 1;
            updateInf = new byte[NetworkLogic.bufSize];
        }
        public void StartProgram()
        {
            Application.Run(menuF);
        }
        public (string, int, bool) ProcessConnectData(string IP, int port, bool auto)
        {
            if (auto)
            {
                IP = NetworkLogic.autoAddr;
                port = NetworkLogic.autoPort;
            }
            try
            {
                netwL = new NetworkLogic(IP, port);
                netwCreated = true;
            }
            catch(Exception e)
            {
                menuF.message = e.Message;
                return (IP, port, false);
            }
            return (IP, port, true);
        }

        public void startGame()
        {
            sendMessage(CreatedCode);
            // какое сообщение отправить 
            gameF = new GameForm(this);

            game = new GameLogic(gameF, updateInf[priorM], this);
            authF.Hide();
            gameF.Show();
            gameF.Refresh();
            if (updateInf[priorM] != 1)
            {
                processMessage();
            }
        }

        public string getGamesInf()
        {
            byte[] recieveBuf;
            int receiveSize = 0;
            byte[] sendBuf = new byte[2];
            sendBuf[codeM] = GetGamesDataCode;
            netwL.sendClientMess(sendBuf);
            (recieveBuf, receiveSize) = netwL.getServerMess();
            return Encoding.UTF8.GetString(recieveBuf);
        }

        public void StartAuthorization()
        {
            menuF.Hide();
            authF.Show();
            updateInf = new byte[NetworkLogic.bufSize];

        }

        public bool Authorize(string login, string password, int authCode)
        {
            // формат сообщения запроса авторизации
            //код(авторизация/регистрация)- байт в буфере,login,passHash
            Array.Clear(updateInf, 0, updateInf.Length);
            updateInf[codeM] = (byte)authCode;
            string passHash = ComputeHash(password);
            byte[] strBuf = Encoding.UTF8.GetBytes(","+login+","+passHash+",");
            Array.Copy(strBuf, 0, updateInf, 1, strBuf.Length);
            netwL.sendClientMess(updateInf);
            (updateInf, infSize) = netwL.getServerMess(); 

            string answ = Encoding.UTF8.GetString(updateInf, 1, updateInf.Length - 1);
            string[] answData = answ.Split(',');
            authF.message = answData[1];
            if (updateInf[codeM] == AuthSuccess)
            {

                authF.Hide();
                userF.Show();


                if (!int.TryParse(answData[2], out userId))
                {
                    userId = 0;
                }
                return true;
            }
            else if (updateInf[codeM] == AuthFailed)
            {
                return false;
            }
            return false;
        }

        public void processMessage()
        {
            (updateInf, infSize) = netwL.getServerMess();
            byte code = updateInf[codeM];
            if (code == OKCode || code == GameOverCode)
            {
                int newX1 = indXMax - updateInf[col1M];
                int newY1 = indYMax - updateInf[row1M];
                int newX2 = indXMax - updateInf[col2M];
                int newY2 = indYMax - updateInf[row2M];
                game.simulate = true;

                if (game.buttons[newY1, newX1].BackColor != Color.Red)
                {
                    game.buttons[newY1, newX1].PerformClick();
                }
                Thread.Sleep(250);
                game.buttons[newY2, newX2].PerformClick();
                game.simulate = false;

                if (code == GameOverCode)
                {
                    string loose;
                    if (updateInf[priorM] == 1)
                    {
                        loose = "Белые";
                    }
                    else
                    {
                        loose = "Чёрные";
                    }
                    menuF.message = loose + " проиграли:(";
                    menuF.showMessage("Message");
                    returnToMenu();
                    game = null;
                    GameFinished = true;
                }
                else
                {
                    if (updateInf[isLastMotion] == 0) 
                    {
                        // Если соперник не закончил свой ход, то ему отсылается информация, говорящая о том, что
                        // своё поле мы обновили, он может продолжать ходы
                        updateInf[codeM] = ContinueCode;
                        netwL.sendClientMess(updateInf);
                        processMessage();
                    }
                }
            }
            else if(code == QuitCode)
            {
                menuF.message = "Ваш соперник покинул игру:(";
                menuF.showMessage("Message");
                returnToMenu();
                game = null;
                GameFinished = true;
            }
            else if (code != ContinueCode)
            {
                menuF.message = "Возникла ошибка! Невозможно продолжить игру:(";
                menuF.showMessage("Error");
                returnToMenu();
                game = null;
                GameFinished = true;
            }
        }
        public void returnToMenu()
        {
            gameF.Hide();
            userF.Show();
        }
        public void sendMessage(byte messCode)
        {
            Array.Clear(updateInf,0,updateInf.Length);
            updateInf[codeM] = messCode;
            if (messCode == OKCode || messCode == GameOverCode)
            {
                updateInf[col1M] = (byte)game.lastStartX;
                updateInf[row1M] = (byte)game.lastStartY;
                updateInf[col2M] = (byte)game.lastEndX;
                updateInf[row2M] = (byte)game.lastEndY;

                updateInf[userIdM] = (byte)userId;

                updateInf[isLastMotion] = game.isLastMotion ? (byte)1 : (byte)0;
                if (messCode == OKCode)
                {
                    netwL.sendClientMess(updateInf);
                    processMessage();
                }
                else
                {
                    string winners;
                    if (updateInf[priorM] != 1)
                    {
                        winners = "Чёрные";
                    }
                    else
                    {
                        winners = "Белые";
                    }
                    netwL.sendClientMess(updateInf);
                    menuF.message = "Поздравляем! " + winners + " шашки победили:)";
                    menuF.showMessage("Message");
                    returnToMenu();
                    game = null;
                    GameFinished = true; 
                }
            }
            else if(messCode == CreatedCode)
            {
                updateInf[userIdM] = (byte)userId;
                netwL.sendClientMess(updateInf);
                (updateInf, infSize) = netwL.getServerMess();
            }
            else if (messCode == AuthCode)
            {
                netwL.sendClientMess(updateInf);
                (updateInf, infSize) = netwL.getServerMess();
            }
        }
        public void netwDisconnect()
        {
            netwL.disconnect();
            netwL = null;
        }




        static string ComputeHash(string input)
        {
            // Преобразуем строку в массив байтов
            byte[] inputBytes = Encoding.UTF8.GetBytes(input);

            // Используем SHA256 для вычисления хэша
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] hashBytes = sha256.ComputeHash(inputBytes);

                // Преобразуем байты хэша в строку в формате HEX
                return BitConverter.ToString(hashBytes).Replace("-", "").ToLowerInvariant();
            }
        }



    }
}
