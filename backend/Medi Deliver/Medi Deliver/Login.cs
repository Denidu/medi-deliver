﻿using Microsoft.Azure.CosmosRepository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Medi_Deliver
{
    public class Login: Item
    {
        public string UserName { get; set; }
        public string Password { get; set; }
    }
}
