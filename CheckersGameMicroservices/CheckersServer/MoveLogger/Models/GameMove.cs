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
    [Table("game_move", Schema = "dbo")]

    public class GameMove
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        [Column("id")] 
        public long Id { get; set; }

        [Column("game_id")]
        public long GameId { get; set; }

        [ForeignKey("GameId")]
        public Game Game { get; set; }

        [Column("player_id")]
        public long PlayerId { get; set; }

        [Column("x_start")]
        public byte xStart {  get; set; }

        [Column("y_start")]
        public byte yStart { get; set; }

        [Column("x_end")]
        public byte xEnd { get; set; }

        [Column("y_end")]
        public byte yEnd { get; set; }

        [Column("move_code")]
        public int moveCode { get; set; }

        [Column("move_timestamp")]
        public DateTime MoveTimestamp { get; set; }
    }
}
