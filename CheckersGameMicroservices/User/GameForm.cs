namespace Checkers
{
    public partial class GameForm : Form
    {
        public Controller controller;
        public GameForm(Controller cntrl)
        {
            InitializeComponent();
            controller = cntrl;
        }

        private void GameForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            byte[] exitData = new byte[NetworkLogic.bufSize];
            exitData[0] = Controller.QuitCode;
            controller.netwL.sendClientMess(exitData);
            controller.netwCreated = false;
            controller.userF.Show();
        }

        private void GameForm_Load(object sender, EventArgs e)
        {

        }
    }
}
