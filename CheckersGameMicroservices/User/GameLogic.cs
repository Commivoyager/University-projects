using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Checkers
{
    internal class GameLogic
    {
        public int lastDelX, lastDelY;
        public int x1, y1, x2, y2; 
        public int lastStartX, lastStartY;
        public int lastEndX, lastEndY;
        public bool isLastMotion;
        public bool isWin = false;
        public bool isMoved = false;
        Controller controller;

        public const int mapSize = 8;
        const int cellSize = 100;
        static string imgDir = System.IO.Path.GetFullPath(System.IO.Path.Combine(Environment.CurrentDirectory, @"..\..\..\images\"));

        GameForm form;
        int currentPlayer;

        List<Button> simpleSteps = new List<Button>();

        int countEatSteps = 0;
        Button prevButton;
        Button pressedButton;

        // Можно ли после съедобного хода есть дальше
        bool isContinue = false;

        bool isMoving;

        int[,] map = new int[mapSize, mapSize];

        public Button[,] buttons = new Button[mapSize, mapSize];
        Image whiteFigure = new Bitmap(new Bitmap(imgDir + "white.png"), new Size(cellSize - 10, cellSize - 10));
        Image blackFigure = new Bitmap(new Bitmap(imgDir + "black.png"), new Size(cellSize - 10, cellSize - 10));
        Image whiteKingFigure = new Bitmap(new Bitmap(imgDir + "whiteKing.png"), new Size(cellSize - 10, cellSize - 10));
        Image blackKingFigure = new Bitmap(new Bitmap(imgDir + "blackKing.png"), new Size(cellSize - 10, cellSize - 10));

        int oppInd;
        int ownInd;
        public bool simulate = false;

        public GameLogic(GameForm frm, int priority, Controller cntrlr)
        {
            controller = cntrlr;
            ownInd = priority;
            oppInd = priority == 1 ? 2 : 1;
            form = frm;
            Init();
        }

        public void Init()
        {
            currentPlayer = 1;
            isMoving = false;
            prevButton = null;

            map = new int[mapSize, mapSize] {
                { 0,oppInd,0,oppInd,0,oppInd,0,oppInd },
                { oppInd,0,oppInd,0,oppInd,0,oppInd,0 },
                { 0,oppInd,0,oppInd,0,oppInd,0,oppInd },
                { 0,0,0,0,0,0,0,0 },
                { 0,0,0,0,0,0,0,0 },
                { ownInd,0,ownInd,0,ownInd,0,ownInd,0 },
                { 0,ownInd,0,ownInd,0,ownInd,0,ownInd },
                { ownInd,0,ownInd,0,ownInd,0,ownInd,0 }
            };

            CreateMap();
        }
        public void ResetGame()
        {
            bool player1 = false;
            bool player2 = false;

            for (int i = 0; i < mapSize; i++)
            {
                for (int j = 0; j < mapSize; j++)
                {
                    if (map[i, j] == 1)  
                        player1 = true;
                    if (map[i, j] == 2)
                        player2 = true;
                }
            }
            // Условие: если шашек одного из игроков не осталось на поле
            // (т.е. он если один игрок проиграл)
            if (!player1 || !player2)
            {
                isWin = true;
            }
        }

        public void CreateMap()
        {
            form.Width = (int)((mapSize + 0.2) * cellSize);
            form.Height = (int)((mapSize + 0.5) * cellSize);

            for (int i = 0; i < mapSize; i++)
            {
                for (int j = 0; j < mapSize; j++)
                {
                    Button button = new Button();
                    button.Location = new Point(j * cellSize, i * cellSize);
                    button.Size = new Size(cellSize, cellSize);
                    button.Click += new EventHandler(OnFigurePress);
                    if (map[i, j] == 1)
                        button.Image = whiteFigure;
                    else if (map[i, j] == 2) button.Image = blackFigure;

                    button.BackColor = GetPrevButtonColor(button);
                    buttons[i, j] = button;
                    form.Controls.Add(button);
                }
            }
        }

        public void SwitchPlayer()
        {
            currentPlayer = currentPlayer == 1 ? 2 : 1;
            ResetGame();
        }

        public Color GetPrevButtonColor(Button prevButton)
        {
            if ((prevButton.Location.Y / cellSize % 2) != 0)
            {
                if ((prevButton.Location.X / cellSize % 2) == 0)
                {
                    return Color.Gray;
                }
            }
            if ((prevButton.Location.Y / cellSize) % 2 == 0)
            {
                if ((prevButton.Location.X / cellSize) % 2 != 0)
                {
                    return Color.Gray;
                }
            }
            return Color.White;
        }

        public void OnFigurePress(object sender, EventArgs e)
        {
            lastDelX = mapSize;
            lastDelY = mapSize;
            if (prevButton != null)
                prevButton.BackColor = GetPrevButtonColor(prevButton);

            pressedButton = sender as Button;

            // Если текущий игрок кликнул на свою же шашку
            if (map[pressedButton.Location.Y / cellSize, pressedButton.Location.X / cellSize] != 0 && map[pressedButton.Location.Y / cellSize, pressedButton.Location.X / cellSize] == currentPlayer)
            {
                CloseSteps();
                // Выбранная пользователем шашка подсвечивается красным
                pressedButton.BackColor = Color.Red;
                DeactivateAllButtons();
                pressedButton.Enabled = true;
                countEatSteps = 0;
                if (pressedButton.Image == whiteKingFigure || pressedButton.Image == blackKingFigure)
                    ShowSteps(pressedButton.Location.Y / cellSize, pressedButton.Location.X / cellSize, false);
                else ShowSteps(pressedButton.Location.Y / cellSize, pressedButton.Location.X / cellSize);

                if (isMoving)
                {
                    CloseSteps();
                    pressedButton.BackColor = GetPrevButtonColor(pressedButton);
                    ShowPossibleSteps();
                    isMoving = false;
                }
                else
                    isMoving = true;
            }
            else
            {
                if (isMoving)
                {
                    isContinue = false;
                    if (Math.Abs(pressedButton.Location.X / cellSize - prevButton.Location.X / cellSize) > 1)
                    {
                        isContinue = true;
                        (lastDelX, lastDelY) = DeleteEaten(pressedButton, prevButton);
                    }
                    y2 = pressedButton.Location.Y / cellSize;
                    x2 = pressedButton.Location.X / cellSize;
                    y1 = prevButton.Location.Y / cellSize;
                    x1 = prevButton.Location.X / cellSize;
                    lastStartX = x1;
                    lastStartY = y1;
                    lastEndX = x2;
                    lastEndY = y2;

                    int temp = map[y2, x2];
                    // В новой ячейке оказывается перемещаемая кнопка
                    map[y2, x2] = map[y1, x1];
                    map[y1, x1] = temp;
                    pressedButton.Image = prevButton.Image;
                    prevButton.Image = null;
                    SwitchButtonToCheat(pressedButton);
                    
                    isMoved = true;
                    countEatSteps = 0;
                    isMoving = false;
                    CloseSteps();
                    DeactivateAllButtons();
                    if (pressedButton.Image == whiteKingFigure || pressedButton.Image == blackKingFigure)
                        ShowSteps(pressedButton.Location.Y / cellSize, pressedButton.Location.X / cellSize, false);
                    else ShowSteps(pressedButton.Location.Y / cellSize, pressedButton.Location.X / cellSize);
                    if (countEatSteps == 0 || !isContinue)
                    {
                        CloseSteps();
                        SwitchPlayer();
                        ShowPossibleSteps();
                        isContinue = false;
                    }
                    else if (isContinue)
                    {
                        pressedButton.BackColor = Color.Red;
                        pressedButton.Enabled = true;
                        isMoving = true;
                    }

                    isLastMotion = !isContinue;
                    prevButton = pressedButton;
                    if (!simulate)
                    {
                        byte code;
                        if (isWin)
                        {
                            code = Controller.GameOverCode;
                        }
                        else
                        {
                            code = Controller.OKCode;
                        }
                        controller.sendMessage(code);
                    }
                    if (isLastMotion)
                    {}
                }
            }

            prevButton = pressedButton;
        }

        public void ShowPossibleSteps()
        {
            bool isOneStep = true;
            bool isEatStep = false;
            Button[,] newbuttons = new Button[mapSize, mapSize];
            for (int i = 0; i < mapSize; i++)
            {
                for (int j = 0; j < mapSize; j++)
                {
                    newbuttons[i, j] = buttons[i, j];
                    newbuttons[i, j].Enabled = false;
                }   
            }
            for (int i = 0; i < mapSize; i++)
            {
                for (int j = 0; j < mapSize; j++)
                {
                    if (map[i, j] == currentPlayer)
                    {
                        if (buttons[i, j].Image == whiteKingFigure || buttons[i, j].Image == blackKingFigure)
                            isOneStep = false;
                        else isOneStep = true;
                        if (IsButtonHasEatStep(i, j, isOneStep, new int[2] { 0, 0 }))
                        {
                            isEatStep = true;
                            newbuttons[i, j].Enabled = true;
                        }
                    }
                }
            }
            if (!isEatStep)
            {
                ActivateAllButtons();
            }
            else
            {
                buttons = newbuttons;
            }

        }

        // Замена шашки на дамку, если она достигла границы поля
        public void SwitchButtonToCheat(Button button)
        {
            if (map[button.Location.Y / cellSize, button.Location.X / cellSize] == oppInd && button.Location.Y / cellSize == mapSize - 1) 
            {
                if(oppInd == 1)
                {
                    button.Image = whiteKingFigure;
                }
                else
                {
                    button.Image = blackKingFigure;
                }
            }
            if (map[button.Location.Y / cellSize, button.Location.X / cellSize] == ownInd && button.Location.Y / cellSize == 0)
            {
                if (ownInd == 1)
                {
                    button.Image = whiteKingFigure;
                }
                else
                {
                    button.Image = blackKingFigure;
                }
            }
        }

        public (int, int) DeleteEaten(Button endButton, Button startButton)
        {
            int delX = mapSize, delY = mapSize;
            // Удаляются все шашки, лежащие по этому направлению
            int count = Math.Abs(endButton.Location.Y / cellSize - startButton.Location.Y / cellSize);
            int startIndexX = endButton.Location.Y / cellSize - startButton.Location.Y / cellSize;
            int startIndexY = endButton.Location.X / cellSize - startButton.Location.X / cellSize;
            startIndexX = startIndexX < 0 ? -1 : 1;
            startIndexY = startIndexY < 0 ? -1 : 1;
            int currCount = 0;
            int i = startButton.Location.Y / cellSize + startIndexX;
            int j = startButton.Location.X / cellSize + startIndexY;
            while (currCount < count - 1)
            {
                if(map[i, j] != 0)
                {
                    delX = j;
                    delY = i;
                }
                map[i, j] = 0;
                buttons[i, j].Image = null;
                buttons[i, j].Text = "";
                i += startIndexX;
                j += startIndexY;
                currCount++;
            }
            return (delX, delY);
        }

        public void ShowSteps(int iCurrFigure, int jCurrFigure, bool isOnestep = true)
        {
            simpleSteps.Clear();
            ShowDiagonal(iCurrFigure, jCurrFigure, isOnestep);
            if (countEatSteps > 0)
                CloseSimpleSteps(simpleSteps);
        }

        public void ShowDiagonal(int IcurrFigure, int JcurrFigure, bool isOneStep = false)
        {
            // Рассматривается для движения вверх и вправо
            int j = JcurrFigure + 1;
            for (int i = IcurrFigure - 1; i >= 0; i--)
            {
                if (currentPlayer == oppInd && isOneStep && !isContinue) break;  
                if (IsInsideBorders(i, j))
                {
                    if (!DeterminePath(i, j))
                        break;
                }
                if (j < 7)
                    j++;
                else break;

                if (isOneStep)
                    break;
            }

            j = JcurrFigure - 1;
            for (int i = IcurrFigure - 1; i >= 0; i--)
            {
                if (currentPlayer == oppInd && isOneStep && !isContinue) break;
                if (IsInsideBorders(i, j))
                {
                    if (!DeterminePath(i, j))
                        break;
                }
                if (j > 0)
                    j--;
                else break;

                if (isOneStep)
                    break;
            }

            j = JcurrFigure - 1;
            for (int i = IcurrFigure + 1; i < 8; i++)
            {
                if (currentPlayer == ownInd && isOneStep && !isContinue) break;
                if (IsInsideBorders(i, j))
                {
                    if (!DeterminePath(i, j))
                        break;
                }
                if (j > 0)
                    j--;
                else break;

                if (isOneStep)
                    break;
            }

            j = JcurrFigure + 1;
            for (int i = IcurrFigure + 1; i < 8; i++)
            {
                if (currentPlayer == ownInd && isOneStep && !isContinue) break;
                if (IsInsideBorders(i, j))
                {
                    if (!DeterminePath(i, j))
                        break;
                }
                if (j < 7)
                    j++;
                else break;

                if (isOneStep)
                    break;
            }
        }

        // Оперделение и отображение пути для хода шашки
        public bool DeterminePath(int ti, int tj)
        {

            if (map[ti, tj] == 0 && !isContinue)
            {
                buttons[ti, tj].BackColor = Color.Yellow;
                buttons[ti, tj].Enabled = true;
                simpleSteps.Add(buttons[ti, tj]);
            }
            else
            {

                if (map[ti, tj] != currentPlayer)
                {
                    if (pressedButton.Image == whiteKingFigure || pressedButton.Image == blackKingFigure)
                        ShowProceduralEat(ti, tj, false);
                    else ShowProceduralEat(ti, tj);
                }

                return false;
            }
            return true;
        }

        // Возможные шаги на поле подсвечиваются, у этих клеток нужно после хода восстанавливать цвет на прежний
        public void CloseSimpleSteps(List<Button> simpleSteps)
        {
            if (simpleSteps.Count > 0)
            {
                for (int i = 0; i < simpleSteps.Count; i++)
                {
                    simpleSteps[i].BackColor = GetPrevButtonColor(simpleSteps[i]);
                    simpleSteps[i].Enabled = false;
                }
            }
        }

        // Метод, чтобы пометить клетки, находящиеся за клетками под боем
        public void ShowProceduralEat(int i, int j, bool isOneStep = true)
        {
            int dirX = i - pressedButton.Location.Y / cellSize;
            int dirY = j - pressedButton.Location.X / cellSize;
            dirX = dirX < 0 ? -1 : 1;
            dirY = dirY < 0 ? -1 : 1;
            int il = i;
            int jl = j;
            // true, если на пути нет шашек противника
            bool isEmpty = true;
            while (IsInsideBorders(il, jl))
            {
                // Поиск шашки противника на пути
                if (map[il, jl] != 0 && map[il, jl] != currentPlayer)
                {
                    isEmpty = false;
                    break;
                }
                il += dirX;
                jl += dirY;

                if (isOneStep)
                    break;
            }
            // Если на этом пути нет ни одной шашки противника, то выходим
            if (isEmpty)
                return;
            // Если есть, то il и jl находятся на ячейке, где будет находиться
            // эта шашка противника под боем
            List<Button> toClose = new List<Button>();
            // Нужно ли закрыть обычные ходы (несъедобные), когда у выбранной шашки
            // есть съедобные шаги
            bool closeSimple = false;
            int ik = il + dirX;
            int jk = jl + dirY;
            // Проходимся по кнопкам, чтобы окрасить в жёлтый те, которые доступны для хода
            while (IsInsideBorders(ik, jk))
            {
                if (map[ik, jk] == 0)
                {
                    if (IsButtonHasEatStep(ik, jk, isOneStep, new int[2] { dirX, dirY }))
                    {
                        closeSimple = true;
                    }
                    else
                    {
                        toClose.Add(buttons[ik, jk]);
                    }
                    buttons[ik, jk].BackColor = Color.Yellow;
                    buttons[ik, jk].Enabled = true;
                    countEatSteps++;
                }
                else break;
                if (isOneStep)
                    break;
                jk += dirY;
                ik += dirX;
            }
            if (closeSimple && toClose.Count > 0)
            {
                CloseSimpleSteps(toClose);
            }

        }

        // isOneStep - является ли не дамкой

        // Метод для определения, есть ли у шашки съедобные ходы
        public bool IsButtonHasEatStep(int IcurrFigure, int JcurrFigure, bool isOneStep, int[] dir)
        {
            bool eatStep = false;
            int j = JcurrFigure + 1;
            for (int i = IcurrFigure - 1; i >= 0; i--) 
            {
                // НЕ дамка 1-ого игрока и шашка, не бьющая другую шашку не может
                // ходить вниз влево по диагонали
                // так как стандартный ход только вверх
                // !isContinue - услвие, не первый ли это съедобный ход
                if (currentPlayer == oppInd && isOneStep && !isContinue) break;
                // То есть случай, когда шашка шла в обратном рассматриваемому направлении
                if (dir[0] == 1 && dir[1] == -1 && !isOneStep) break;
                if (IsInsideBorders(i, j))
                {
                    // проверка, стоит ли там противник
                    if (map[i, j] != 0 && map[i, j] != currentPlayer)
                    {
                        eatStep = true;
                        if (!IsInsideBorders(i - 1, j + 1))
                            eatStep = false; 
                        else if (map[i - 1, j + 1] != 0)
                            eatStep = false;
                        else return eatStep;
                    }
                }
                if (j < 7)
                    j++;
                else break;

                if (isOneStep)
                    break;
            }

            j = JcurrFigure - 1;
            for (int i = IcurrFigure - 1; i >= 0; i--)
            {
                if (currentPlayer == oppInd && isOneStep && !isContinue) break;
                if (dir[0] == 1 && dir[1] == 1 && !isOneStep) break;
                if (IsInsideBorders(i, j))
                {
                    if (map[i, j] != 0 && map[i, j] != currentPlayer)
                    {
                        eatStep = true;
                        if (!IsInsideBorders(i - 1, j - 1))
                            eatStep = false;
                        else if (map[i - 1, j - 1] != 0)
                            eatStep = false;
                        else return eatStep;
                    }
                }
                if (j > 0)
                    j--;
                else break;

                if (isOneStep)
                    break;
            }

            j = JcurrFigure - 1;
            for (int i = IcurrFigure + 1; i < 8; i++)
            {
                if (currentPlayer == ownInd && isOneStep && !isContinue) break;
                if (dir[0] == -1 && dir[1] == 1 && !isOneStep) break;
                if (IsInsideBorders(i, j))
                {
                    if (map[i, j] != 0 && map[i, j] != currentPlayer)
                    {
                        eatStep = true;
                        if (!IsInsideBorders(i + 1, j - 1))
                            eatStep = false;
                        else if (map[i + 1, j - 1] != 0)
                            eatStep = false;
                        else return eatStep;
                    }
                }
                if (j > 0)
                    j--;
                else break;

                if (isOneStep)
                    break;
            }

            j = JcurrFigure + 1;
            for (int i = IcurrFigure + 1; i < 8; i++)
            {
                if (currentPlayer == ownInd && isOneStep && !isContinue) break;
                if (dir[0] == -1 && dir[1] == -1 && !isOneStep) break;
                if (IsInsideBorders(i, j))
                {
                    if (map[i, j] != 0 && map[i, j] != currentPlayer)
                    {
                        eatStep = true;
                        if (!IsInsideBorders(i + 1, j + 1))
                            eatStep = false;
                        else if (map[i + 1, j + 1] != 0)
                            eatStep = false;
                        else return eatStep;
                    }
                }
                if (j < 7)
                    j++;
                else break;

                if (isOneStep)
                    break;
            }
            return eatStep;
        }

        // Чтобы убрать отображение возможных вариантов ходов шашки с поля
        public void CloseSteps()
        {
            for (int i = 0; i < mapSize; i++)
            {
                for (int j = 0; j < mapSize; j++)
                {
                    // Устанавливает цвет ячейки, который у неё должен быть по расположению
                    buttons[i, j].BackColor = GetPrevButtonColor(buttons[i, j]);
                }
            }
        }

        public bool IsInsideBorders(int ti, int tj)
        {
            if (ti >= mapSize || tj >= mapSize || ti < 0 || tj < 0)
            {
                return false;
            }
            return true;
        }

        public void ActivateAllButtons()
        {
            for (int i = 0; i < mapSize; i++)
            {
                for (int j = 0; j < mapSize; j++)
                {
                    buttons[i, j].Enabled = true;
                }
            }
        }

        public void DeactivateAllButtons()
        {
            for (int i = 0; i < mapSize; i++)
            {
                for (int j = 0; j < mapSize; j++)
                {
                    buttons[i, j].Enabled = false;
                }
            }
        }
    }
}