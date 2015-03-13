import UIKit
import GPUImage

class ViewController: UIViewController
    , UIImagePickerControllerDelegate
    , UINavigationControllerDelegate
    , SelectFilterDelegate
{

    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var beforAfterControl: UISegmentedControl!
    var imageSource: UIImage!;
    var imageNow: UIImage!;
    var focusCenter: CIVector!;
    var focusRadius0: Float!;
    var focusRadius1: Float!;
    
    var selectedFilterSection: Int = (-1);
    var selectedFilterRow: Int = (-1);
    
    enum pickerModeType : Int
    {
        case sourceSelect = 0, overlaySelect
    }
    var pickerMode: pickerModeType = pickerModeType.sourceSelect;

    enum selectImage : Int
    {
        case befor = 0, after
    }
    var beforAfter: selectImage = selectImage.befor;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // AutoLayoutを使用するとviewDidLoadではframeが確定しない
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        // AutoLayoutを使用するとframeが確定するのはここ
        beforAfterControl.addTarget(self, action: "beforAfterChange:", forControlEvents: UIControlEvents.ValueChanged);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickImageAction(sender: UIBarButtonItem) {
        
        pickerMode = pickerModeType.sourceSelect;
        
        let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        
        if(UIImagePickerController.isSourceTypeAvailable(sourceType))
        {
            let picker: UIImagePickerController = UIImagePickerController();
            picker.sourceType = sourceType;
            picker.delegate = self;
            self.presentViewController(picker, animated: true, completion: nil);
        }
        
    }
    
    @IBAction func filtersSelectAction(sender: UIBarButtonItem) {
        
        // フィルタ選択
        if let image = imageSource
        {
            var selectView = self.storyboard?.instantiateViewControllerWithIdentifier("SelectFilterVC") as UIViewController;
            self.presentViewController(selectView, animated: true, completion: { () -> Void in
                
            })
        }
    }
    
    @IBAction func imageSave(sender: UIBarButtonItem) {
        if let image = imageNow
        {
            UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil);
        }
    }
    func image(image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutablePointer<Void>)
    {
        if error != nil
        {
            let alert:UIAlertController = UIAlertController(title:"保存失敗",
                message:NSString(format:"errorcode : %d", error.code) as String,
                preferredStyle: UIAlertControllerStyle.Alert);
            
            //Cancel 一つだけしか指定できない
            let cancelAction:UIAlertAction = UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Cancel,
                handler:{(action:UIAlertAction!) -> Void in
            })
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil);
        }
    }
    
    func filterSelectFinish(section: Int, row: Int)
    {
        selectedFilterSection = section;
        selectedFilterRow = row;
        if(section >= 0 && section != 2)
        {
            imageNow = ImageProcessing.filter_exec((beforAfter == selectImage.befor) ? imageSource : imageNow,
                section: section,
                row: row);
            self.showImageView.image = imageNow;

            beforAfter = selectImage.after;
            beforAfterControl.selectedSegmentIndex = beforAfter.rawValue;
        }
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            if(self.selectedFilterSection == 2)
            {
                // オーバレイ画像を選択する

                let alert:UIAlertController = UIAlertController(title:"ブレンド画像選択",
                    message: nil,
                    preferredStyle: UIAlertControllerStyle.Alert);
                
                //Cancel 一つだけしか指定できない
                let cancelAction:UIAlertAction = UIAlertAction(title: "やめる",
                    style: UIAlertActionStyle.Cancel,
                    handler:{(action:UIAlertAction!) -> Void in
                        
                        self.selectedFilterSection = (-1);
                        self.selectedFilterRow = (-1);
                })
                alert.addAction(cancelAction)

                let defaultAction:UIAlertAction = UIAlertAction(title: "選択する",
                    style: UIAlertActionStyle.Default,
                    handler:{(action:UIAlertAction!) -> Void in
                        
                        self.pickerMode = pickerModeType.overlaySelect;
                        let picker: UIImagePickerController = UIImagePickerController();
                        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                        picker.delegate = self;
                        self.presentViewController(picker, animated: true, completion: nil);
                })
                alert.addAction(defaultAction)

                let sameBaseAction:UIAlertAction = UIAlertAction(title: "同じ画像(ベース)",
                    style: UIAlertActionStyle.Default,
                    handler:{(action:UIAlertAction!) -> Void in
                        
                        self.imageNow = ImageProcessing.filter_exec(
                            (self.beforAfter == selectImage.befor) ? self.imageSource : self.imageNow,
                            section: self.selectedFilterSection,
                            row: self.selectedFilterRow,
                            overlay: self.imageSource);
                        self.showImageView.image = self.imageNow;
                        
                        self.beforAfter = selectImage.after;
                        self.beforAfterControl.selectedSegmentIndex = self.beforAfter.rawValue;
                })
                alert.addAction(sameBaseAction)
                
                if((self.beforAfter == selectImage.after))
                {
                    let sameAction:UIAlertAction = UIAlertAction(title: "表示中の画像",
                        style: UIAlertActionStyle.Default,
                        handler:{(action:UIAlertAction!) -> Void in
                            
                            self.imageNow = ImageProcessing.filter_exec(
                                self.imageNow,
                                section: self.selectedFilterSection,
                                row: self.selectedFilterRow,
                                overlay: self.imageNow);
                            self.showImageView.image = self.imageNow;
                            
                            self.beforAfter = selectImage.after;
                            self.beforAfterControl.selectedSegmentIndex = self.beforAfter.rawValue;
                    })
                    alert.addAction(sameAction)
                }
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        });
    }
    
    @IBAction func RepeatFilterAction(sender: UIBarButtonItem) {
        self.filterSelectFinish(self.selectedFilterSection, row: self.selectedFilterRow);
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let dic: NSDictionary = info;
        
        if(pickerMode == pickerModeType.overlaySelect && self.selectedFilterSection == 2)
        {
            
            imageNow = ImageProcessing.filter_exec((beforAfter == selectImage.befor) ? imageSource : imageNow,
                section: selectedFilterSection,
                row: selectedFilterRow,
                overlay: dic.objectForKey(UIImagePickerControllerOriginalImage) as? UIImage);
            self.showImageView.image = imageNow;
            
            beforAfter = selectImage.after;
            beforAfterControl.selectedSegmentIndex = beforAfter.rawValue;
        }
        else
        {
            imageSource = dic.objectForKey(UIImagePickerControllerOriginalImage) as UIImage;
            imageNow = dic.objectForKey(UIImagePickerControllerOriginalImage) as UIImage;
            
            // そのまま表示
            self.showImageView.image = self.imageSource;

            beforAfter = selectImage.befor;
            beforAfterControl.selectedSegmentIndex = beforAfter.rawValue;
        }

        // 閉じる
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        });
    }
    
    func beforAfterChange(seg: UISegmentedControl)
    {
        if(seg.selectedSegmentIndex == selectImage.after.rawValue)
        {
            beforAfter = selectImage.after;
            self.showImageView.image = imageNow;
        }
        else
        {
            beforAfter = selectImage.befor;
            self.showImageView.image = imageSource;
        }
    }
    
}

