import UIKit
import GPUImage

protocol ToneCurveVCDelegate
{
    func ToneCurveFinish(afterImage: UIImage, isDone: Bool);
}

class ToneCurveLeftView: UIView
{
    override func drawRect(rect: CGRect) {
        
        var context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        
        CGContextAddRect(context, self.frame);
        
        var colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        var components: [CGFloat] = [
            // R, G, B, Alpha
            0.0, 0.0, 0.0, 1.0,
            1.0, 1.0, 1.0, 1.0
        ];
        var locations: [CGFloat] = [0.0, 1.0];
        
        let componentsSize = (UInt(components.count) * UInt(sizeof(CGFloat)));
        let rgbaSize = (UInt(sizeof(CGFloat)) * 4);
        let count = componentsSize / rgbaSize;
        
        var frame = self.bounds;
        var startPoint = frame.origin;
        var endPoint = frame.origin;
        endPoint.y = endPoint.y + frame.size.height;
        
        let gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, components, locations, count);
        
        CGContextDrawLinearGradient(context, gradientRef, startPoint, endPoint, 0);
        
        CGContextRestoreGState(context);
    }
}
class ToneCurveRightView: UIView
{
    override func drawRect(rect: CGRect) {
        
        var context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        
        CGContextAddRect(context, self.frame);
        
        var colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        var components: [CGFloat] = [
            // R, G, B, Alpha
            1.0, 1.0, 1.0, 1.0,
            0.0, 0.0, 0.0, 1.0
        ];
        var locations: [CGFloat] = [0.0, 1.0];
        
        let componentsSize = (UInt(components.count) * UInt(sizeof(CGFloat)));
        let rgbaSize = (UInt(sizeof(CGFloat)) * 4);
        let count = componentsSize / rgbaSize;
        
        var frame = self.bounds;
        var startPoint = frame.origin;
        var endPoint = frame.origin;
        endPoint.x = endPoint.x + frame.size.width;
        
        let gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, components, locations, count);
        
        CGContextDrawLinearGradient(context, gradientRef, startPoint, endPoint, 0);
        
        CGContextRestoreGState(context);
    }
}

class ToneCurveView: UIView
{
    override func drawRect(rect: CGRect) {
        
        // UIBezierPath のインスタンス生成
        var line = UIBezierPath();
        
        // 起点
        line.moveToPoint(CGPointMake(50, 50));
        
        // 帰着点
        line.addLineToPoint(CGPointMake(220,350));
        
        // 色の設定
        UIColor.redColor().setStroke()
        
        // ライン幅
        line.lineWidth = 2
        
        // 描画
        line.stroke();
    }
}

class ToneCurveVC: UIViewController
    , UINavigationControllerDelegate
    , UITextFieldDelegate
    , MainVCDelegate
{
    var delegate: ToneCurveVCDelegate!;
    
    @IBOutlet weak var preview: UIImageView!
    
    var imageSource: UIImage!;
    var imageNow: UIImage!;
    
    var points: NSArray = [NSValue(CGPoint: CGPointMake(0.0, 0.0)), NSValue(CGPoint: CGPointMake(1.0, 1.0))];
    var points_r: NSArray = [NSValue(CGPoint: CGPointMake(0.0, 0.0)), NSValue(CGPoint: CGPointMake(1.0, 1.0))];
    var points_g: NSArray = [NSValue(CGPoint: CGPointMake(0.0, 0.0)), NSValue(CGPoint: CGPointMake(1.0, 1.0))];
    var points_b: NSArray = [NSValue(CGPoint: CGPointMake(0.0, 0.0)), NSValue(CGPoint: CGPointMake(1.0, 1.0))];
    
    func passImageSource(baseImage: UIImage)
    {
        imageSource = baseImage;
        imageNow = ImageProcessing.toneCurveFilter(imageSource);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
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
        delegate.ToneCurveFinish(imageNow, isDone: true);
    }
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        
        delegate = self.presentingViewController as ViewController;
        delegate.ToneCurveFinish(imageNow, isDone: false);
    }
}

