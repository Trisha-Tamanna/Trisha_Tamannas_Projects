using RestaurantManagement.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RestaurantManagement.Repositories
{
    public class MenuItemRepository:IMenuItemRepository
    {
        private readonly List<MenuItem> _menuItems = new List<MenuItem>();

        public IEnumerable<MenuItem> GetAll()
        {
            return _menuItems;
        }
        public MenuItem GetById(int id)
        {
            return _menuItems.FirstOrDefault(x => x.Id == id);
        }
        public void Add(MenuItem menuItem)
        {
           _menuItems.Add(menuItem);
        }



        public void Update(MenuItem menuItem)
        {
            var existingItem=GetById(menuItem.Id);
            if (existingItem!=null)
            {
                existingItem.Name = menuItem.Name;
                existingItem.Price = menuItem.Price;
            }
        }


        public void Delete(int id)
        {
            var menuItem = GetById(id);
            if (menuItem != null)
            {
                _menuItems.Remove(menuItem);
            }
        }

    }
}
