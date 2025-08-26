using DBService.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DBService.Models
{
    [Table("game", Schema = "dbo")]

    public class Game
    {
        [Key] // Primary key
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)] // generates auto
        [Column("id")] // column name
        public long Id { get; set; } // Primary key

        [Column("player1_id")]
        public long Player1Id { get; set; }
        [Column("player2_id")]
        public long Player2Id { get; set; }

        [Column("start_time")]
        public DateTime StartTime { get; set; }

        [Column("end_time")]
        public DateTime EndTime { get; set; }


        [Column("winner_id")]
        public long WinnerId { get; set; }
        [Column("interrupted_flag")]
        public bool IsInterrupted { get; set; } = false;




        public List<GameMove> Moves { get; set; }

    }
}

