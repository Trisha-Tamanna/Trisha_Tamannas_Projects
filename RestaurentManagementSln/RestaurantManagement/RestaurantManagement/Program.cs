using RestaurantManagement.Repositories;
using RestaurantManagement.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RestaurantManagement
{
    public class Program
    {
        static void Main(string[] args)
        {
            IMenuItemRepository menuItemRepository = new MenuItemRepository();  
            MenuService menuService=new MenuService(menuItemRepository);
            while (true)
            {
                Console.WriteLine("1. Display Menu");
                Console.WriteLine("2. Add Menu Item");
                Console.WriteLine("3. Update Menu Item");
                Console.WriteLine("4. Delete Menu Item");
                Console.WriteLine("5. Exit");
                Console.Write("Select an option: ");
                var option=Console.ReadLine();

                switch(option)
                {
                    case "1":
                        menuService.DisplayMenu();
                        break;
                    case "2":
                        Console.Write("Enter name: ");
                        var name = Console.ReadLine();
                        Console.Write("Enter price: ");
                        decimal price = decimal.Parse(Console.ReadLine());
                        menuService.AddMenuItem(name, price);
                        break;
                    case "3":
                        Console.Write("Enter ID: ");
                        int id = int.Parse(Console.ReadLine());
                        Console.Write("Enter new name: ");
                        name = Console.ReadLine();
                        Console.Write("Enter new price: ");
                        price = decimal.Parse(Console.ReadLine());
                        menuService.UpdaterMenuItem(id, name, price);
                        break;
                    case "4":
                        Console.Write("Enter ID: ");
                        id = int.Parse(Console.ReadLine());
                        menuService.DeleteMenuItem(id);
                        break;
                    case "5":
                        return;
                    default:
                        Console.WriteLine("Invalid option");
                        break;
                }
            }
        }
    }
}
