
import UIKit
import Foundation
import Alamofire
import JSONJoy


class TableViewClass: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //Global Variables
    //************************************************************************************************
    var newCellLocation: Int = -1
    var dropDown = false
    var cellCount = 4
    var DropdownTitle:[String]!
    var regularRowHeight:CGFloat = 75
    var largeRowHeight:CGFloat = 300
    var PhotoBaseURL: String = "http://seteventbackend.azurewebsites.net/code/"
    //************************************************************************************************
    
    
    //Storyboard(InterfaceBuilder) connections
    //************************************************************************************************
    @IBOutlet var Photo: UIImageView!
    @IBOutlet var ScrollView: UIScrollView!
    //************************************************************************************************
    
    //This Function is called right before the ViewController(The page representations located in the Main.Storyboard file) named "Binder" is presented to the user
    //The keyword 'override' is used before defining the function because this class' super class, UIViewController, already has a definition for the func 'viewDidLoad'
    override func viewDidLoad() {
        //Binder is a subclass of UIViewController and the 'super' keyword refers to a classes super Class
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        DropdownTitle = ["RoundTable Handouts","Presenter Handouts","Discussion Notes"]
        
        
        //The ScrollView connection defined above. This assigns a height to the ScrollView embeded in the view allowing the user to be presented with a 1000 pixel long View(page) that they can sroll, vertically, through.
        ScrollView.contentSize.height = 1000
        
        
        
        
        //HTTP Request to Web API
        //************************************************************************************************
        //The AlamoFire module being used. The purpose of the Alamofire module is to make Http requests simpler. This version of the "request" function is async to show a different version compared to the rest of the app.
        //The 'nil' keyword describes a non value
        //The .responseJSON is the callback once the the request is fufilled
        //'response' is the variable that holds the information given back by the Web API. It is not declared in my code, it belongs to Alamofire.
        Alamofire.request(.GET, "https://settodolist.azurewebsites.net/tables/EventItem/", parameters: nil, encoding: ParameterEncoding.JSON, headers: ["ZUMO-API-VERSION" : "2.0.0"]).responseJSON { response in
            
            
            //Swift allows for 'optional binding' where if the variable not being declared, or to the right of the equal sign, is not equal to 'nil' or has a value then the variable to the left of the equal sign is created and it then equates to the variable on the right
            //The newly created variable 'JSON' is only available within the the curly braces directly after its declaration
            //response.result.value is of type 'NSCFArray' which is similar to a regular array. This elements within this array can be accessed through bracket indexing ([0]...[10] .etc)
            if let JSON = response.result.value {
                
                /*
                 do {
                 let obj = try Event_Item(JSONDecoder(JSON))
                 //self.textView.text = "Location: \(obj.Location)"
                 } catch {
                 print(JSON)
                 }
                 */
            }
        }
        //************************************************************************************************
        
        
        
        //IF you wanted to display a picture from the web.
        //************************************************************************************************
        //'PhotoBaseURL' is the global varable up above
        
        //let url = NSURL(string: "\(PhotoBaseURL)uploads/images/earth.jpg")
        //let imagedata = NSData(contentsOfURL: url!)
        //Photo.image = UIImage(data: imagedata!)
        //************************************************************************************************
        
        
    }
    //TableView Functions
    //****************************************************************************************************
    //To be able to conform to the 'UITableViewDelegate and UITableViewDataSource' Classes a class must implement two functions, tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int AND tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.
    //In oder to connect a table view from the viewcontroller in Main.Storyboard to the class you must first drag a table view from the Object Library (The pane closest to the bottom left of the screen, with the square within the circle icon, only visible when within the Main.storyboard class [If the right blade that describes objects is not visible click the button furtherst to the right in the three buttons all the way at the top right of the xcode window.]) After the table view is dragged to the view controller you must then control-click the view and the a small window will come up with the attributes 'delegat and data source'. From the circles to the left of their names you must click and drag them to the yellow icon at the top of the viewcontroller. This makes the Binder class become the delegate and datasource for the tableview.
    
    
    //This function tells the table view how many rows to create within the table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //dropDown is a global bool variable that keeps track of whether or not there is another cell added to the table that gives the effect of a drop down menu.
        if dropDown{
            //If dropDown == true one more cell is added to the table underneath the row that was clicked
            //The number of cells in the table is contingent upon the number of elements within the DropdownTitle array which holds all the titles for the table view cells
            return DropdownTitle.count + 1
        }
        return DropdownTitle.count
    }
    //This function is called to create each cell in the table
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //IndexPath.row is the cell location that is being created
        
        //The code below means if the row being created has the same location as the global variable newcelllocation which holds the location of the drop down cell.
        if indexPath.row == newCellLocation {
            //Create cell from a predifined cell in the 'Binder' as the row passed into the function through the parameters as a custom UITableViewCell class.
            let cell = tableView.dequeueReusableCellWithIdentifier("Binder_Cell_1", forIndexPath: indexPath) as! Binder_Cell_1
            
            cell.selectionStyle = UITableViewCellSelectionStyle(rawValue: 0)!
            
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Binder_Cell_0", forIndexPath: indexPath) as! Binder_Cell_0
            cell.drop_Arrow.image = UIImage(named: "DownArrow")
            //This
            if dropDown{
                if indexPath.row > newCellLocation{
                    cell.name.text = DropdownTitle[indexPath.row - 1]
                }else{
                    cell.name.text = DropdownTitle[indexPath.row]
                }
            }else{
                cell.name.text = DropdownTitle[indexPath.row]
            }
            cell.selectionStyle = UITableViewCellSelectionStyle(rawValue: 0)!
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == newCellLocation {
            return largeRowHeight
        }else {
            return regularRowHeight
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
        
        
        //Drop Down Control
        //****************************************************************************************************
        if indexPath.row == newCellLocation - 1 {
            dropDown = false
            //if the cell above the dropdown cell is clicked then assign the newcelllocation global variable to a row that will never be created.
            newCellLocation = -1
            cellCount -= 1
        }
            //If the drop down cell is clicked nothing should happen at the TableView level
        else if indexPath.row == newCellLocation{}
            
        else{
            //if drop down is open
            if dropDown == true{
                if newCellLocation > indexPath.row{
                    newCellLocation = indexPath.row + 1
                    if cellCount < 4{
                        cellCount += 1
                    }
                }else{
                    newCellLocation = indexPath.row
                    if cellCount < 4{
                        cellCount += 1
                    }
                }
                
                //if drop down is closed
            }else{
                newCellLocation = indexPath.row + 1
                if cellCount < 4{
                    cellCount += 1
                    
                }
            }
            dropDown = true
        }
        
        tableView.reloadData()

}
