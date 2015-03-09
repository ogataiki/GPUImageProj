import UIKit

class SelectFilterVC: UIViewController
    , UINavigationControllerDelegate
    , UITableViewDelegate
    , UITableViewDataSource
{
    @IBOutlet weak var filtersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.filtersTableView.delegate = self
        self.filtersTableView.dataSource = self
        
        // AutoLayoutを使用するとviewDidLoadではframeが確定しない
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        // AutoLayoutを使用するとframeが確定するのはここ
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func SelectedFilter(sender: AnyObject) {
        
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        });
    }
    
    @IBAction func SelectedCancel(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        });
    }
    
    //
    // tableview delegate
    //

    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return ImageProcessing.FILTERSECTIONS.count;
    }
    func tableView(tableView: UITableView
        , titleForHeaderInSection section: Int
        ) -> String?
    {
            return ImageProcessing.FILTERSECTIONS[section];
    }
    
    func tableView(tableView: UITableView
        , numberOfRowsInSection section: Int
        ) -> Int
    {
        switch (section) {
        case 0: // color
            return ImageProcessing.COLORFILTERS.count;
        case 1: // processiong
            return ImageProcessing.PROCESSFILTERS.count;
        case 2: // blend
            return ImageProcessing.BLENDFILTERS.count;
        case 3: // visual effect
            return ImageProcessing.VISUALEFFECTFILTERS.count;
        default:
            break;
        }

        return 0;
    }
    
    func tableView(tableView: UITableView
        , cellForRowAtIndexPath indexPath: NSIndexPath
        ) -> UITableViewCell
    {
        let CellIdentifier = "Cell";
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier);

//        // 再利用できるセルがあれば再利用する
//        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as UITableViewCell!;
//        if let tmp = cell
//        {
//            // 再利用できない場合は新規で作成
//        }
        
        switch (indexPath.section) {
        case 0: // color
            cell.textLabel?.text = ImageProcessing.COLORFILTERS[indexPath.row];
            break;
        case 1: // processiong
            cell.textLabel?.text = ImageProcessing.PROCESSFILTERS[indexPath.row];
            break;
        case 2: // blend
            cell.textLabel?.text = ImageProcessing.BLENDFILTERS[indexPath.row];
            break;
        case 3: // visual effect
            cell.textLabel?.text = ImageProcessing.VISUALEFFECTFILTERS[indexPath.row];
            break;
        default:
            break;
        }
        return cell;
    }
    
    // 選択された
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch (indexPath.section) {
        case 0: // color
            ImageProcessing.COLORFILTERS[indexPath.row];
            break;
        case 1: // processiong
            ImageProcessing.PROCESSFILTERS[indexPath.row];
            break;
        case 2: // blend
            ImageProcessing.BLENDFILTERS[indexPath.row];
            break;
        case 3: // visual effect
            ImageProcessing.VISUALEFFECTFILTERS[indexPath.row];
            break;
        default:
            break;
        }
    }
}

