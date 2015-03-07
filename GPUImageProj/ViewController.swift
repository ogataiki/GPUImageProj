import UIKit
import GPUImage

class ViewController: UIViewController
    ,UIImagePickerControllerDelegate
    ,UINavigationControllerDelegate
{

    @IBOutlet weak var showImageView: UIImageView!
    var imageSource: UIImage!;
    var focusCenter: CIVector!;
    var focusRadius0: Float!;
    var focusRadius1: Float!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
    
    @IBAction func pickImageAction(sender: UIBarButtonItem) {
        
        let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        
        if(UIImagePickerController.isSourceTypeAvailable(sourceType))
        {
            let picker: UIImagePickerController = UIImagePickerController();
            picker.sourceType = sourceType;
            picker.delegate = self;
            self.presentViewController(picker, animated: true, completion: nil);
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let dic: NSDictionary = info;
        imageSource = dic.objectForKey(UIImagePickerControllerOriginalImage) as UIImage;
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            // そのまま表示
            // self.showImageView.image = self.imageSource;
            
            // フィルタリングして表示
//            self.showImageView.image = ImageProcessing.gaussianSelectiveBlurFilter(self.imageSource
//                , blurSize: 5.0
//                , radius: 0.4
//                , point: CGPointMake(0.5, 0.5)
//                , exBlurSize: 0.5
//                , aspectRatio: 1.0
//            );

//            self.showImageView.image = ImageProcessing.darkenBlendFilter(self.imageSource
//                , overlayImage: ImageProcessing.sobelEdgeDetectionFilter(self.imageSource)
//            );

            self.showImageView.image = ImageProcessing.polkaDotFilter(self.imageSource
                , fractionalWidthOfAPixel: 0.05
                , dotScaling: 0.9
            );
            
        });
    }
    
    
}

