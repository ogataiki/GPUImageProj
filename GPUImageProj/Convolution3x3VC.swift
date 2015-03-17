import UIKit
import GPUImage

protocol Convolution3x3VCDelegate
{
    func Convolution3x3Finish(afterImage: UIImage, isDone: Bool);
}

class Convolution3x3VC: UIViewController
    , UINavigationControllerDelegate
    , UITextFieldDelegate
    , MainVCDelegate
{
    var delegate: Convolution3x3VCDelegate!;
    
    @IBOutlet weak var preview: UIImageView!
    
    @IBOutlet weak var value0x0: UITextField!
    @IBOutlet weak var value0x1: UITextField!
    @IBOutlet weak var value0x2: UITextField!
    @IBOutlet weak var value1x0: UITextField!
    @IBOutlet weak var value1x1: UITextField!
    @IBOutlet weak var value1x2: UITextField!
    @IBOutlet weak var value2x0: UITextField!
    @IBOutlet weak var value2x1: UITextField!
    @IBOutlet weak var value2x2: UITextField!

    var imageSource: UIImage!;
    var imageNow: UIImage!;
    
    var kernel: GPUMatrix3x3!;

    func passImageSource(baseImage: UIImage)
    {
        imageSource = baseImage;
        
        kernel = GPUMatrix3x3(
            // 初期化
            one:    GPUVector3(one: 0, two: 0, three: 0),
            two:    GPUVector3(one: 0, two: 1, three: 0),
            three:  GPUVector3(one: 0, two: 0, three: 0)
        );
        
        imageNow = ImageProcessing.convolution3x3Filter(imageSource, kernel: kernel);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        value0x0!.delegate = self;
        value0x1!.delegate = self;
        value0x2!.delegate = self;
        value1x0!.delegate = self;
        value1x1!.delegate = self;
        value1x2!.delegate = self;
        value2x0!.delegate = self;
        value2x1!.delegate = self;
        value2x2!.delegate = self;
        
        value0x0.keyboardType = UIKeyboardType.NumbersAndPunctuation;
        value0x1.keyboardType = UIKeyboardType.NumbersAndPunctuation;
        value0x2.keyboardType = UIKeyboardType.NumbersAndPunctuation;
        value1x0.keyboardType = UIKeyboardType.NumbersAndPunctuation;
        value1x1.keyboardType = UIKeyboardType.NumbersAndPunctuation;
        value1x2.keyboardType = UIKeyboardType.NumbersAndPunctuation;
        value2x0.keyboardType = UIKeyboardType.NumbersAndPunctuation;
        value2x1.keyboardType = UIKeyboardType.NumbersAndPunctuation;
        value2x2.keyboardType = UIKeyboardType.NumbersAndPunctuation;
        
        value0x0.returnKeyType = UIReturnKeyType.Done;
        value0x1.returnKeyType = UIReturnKeyType.Done;
        value0x2.returnKeyType = UIReturnKeyType.Done;
        value1x0.returnKeyType = UIReturnKeyType.Done;
        value1x1.returnKeyType = UIReturnKeyType.Done;
        value1x2.returnKeyType = UIReturnKeyType.Done;
        value2x0.returnKeyType = UIReturnKeyType.Done;
        value2x1.returnKeyType = UIReturnKeyType.Done;
        value2x2.returnKeyType = UIReturnKeyType.Done;
        
        value0x0.text = "0";
        value0x1.text = "0";
        value0x2.text = "0";
        value1x0.text = "0";
        value1x1.text = "1";
        value1x2.text = "0";
        value2x0.text = "0";
        value2x1.text = "0";
        value2x2.text = "0";
        
        // AutoLayoutを使用するとviewDidLoadではframeが確定しない
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        // AutoLayoutを使用するとframeが確定するのはここ
        
        preview.image = imageNow;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func doneAction(sender: UIBarButtonItem) {
        
        delegate = self.presentingViewController as ViewController;
        delegate.Convolution3x3Finish(imageNow, isDone: true);
    }
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        
        delegate = self.presentingViewController as ViewController;
        delegate.Convolution3x3Finish(imageNow, isDone: false);
    }

    func kernelUpdate()
    {
        // カーネルを再読み込み
        kernel = GPUMatrix3x3(
            one:    GPUVector3(
                one:    NSString(string: value0x0.text).floatValue,
                two:    NSString(string: value0x1.text).floatValue,
                three:  NSString(string: value0x2.text).floatValue),
            two:    GPUVector3(
                one:    NSString(string: value1x0.text).floatValue,
                two:    NSString(string: value1x1.text).floatValue,
                three:  NSString(string: value1x2.text).floatValue),
            three:  GPUVector3(
                one:    NSString(string: value2x0.text).floatValue,
                two:    NSString(string: value2x1.text).floatValue,
                three:  NSString(string: value2x2.text).floatValue)
        );
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = "";
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        
        // 入力を数値に丸める
        textField.text = NSString(format: "%.2f", NSString(string: textField.text).floatValue);
        
        // イメージ更新
        kernelUpdate();
        imageNow = ImageProcessing.convolution3x3Filter(imageSource, kernel: kernel);
        preview.image = imageNow;

        return true;
    }
}

