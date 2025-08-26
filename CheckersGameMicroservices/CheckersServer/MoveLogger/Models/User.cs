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
    [Table("game_user", Schema = "dbo")]

    public class User
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        [Column("id")]
        public long Id { get; set; }

        [Column("user_name")]
        public string UserName {  get; set; }


        [Column("password_hash")]
        public string PasswordHash {  get; set; }

        [Column("registration_date")]
        public DateTime RegistrDate { get; set; }

    }
}
