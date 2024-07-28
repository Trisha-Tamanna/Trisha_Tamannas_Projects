using RestaurantManagement.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RestaurantManagement.Repositories
{
    public interface IMenuItemRepository
    {
        IEnumerable<MenuItem> GetAll();
        MenuItem GetById(int id);
        void Add(MenuItem menuItem);
        void Update(MenuItem menuItem);
        void Delete(int id);
    }
}
