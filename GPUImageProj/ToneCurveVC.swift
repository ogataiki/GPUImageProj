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
        
        CGContextClearRect(context, rect);
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
        CGContextClearRect(context, rect);
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
    class TouchPoint: UIView
    {
        override init(frame: CGRect) {
            super.init(frame: frame);
            backgroundColor = UIColor.clearColor();
        }

        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func drawRect(rect: CGRect) {
            
            var context = UIGraphicsGetCurrentContext();
            CGContextSaveGState(context);
            CGContextClearRect(context, rect);
        
            let w = self.frame.size.width;
            let h = self.frame.size.height;
            CGContextSetFillColorWithColor(context, UIColor.orangeColor().CGColor);
            CGContextFillEllipseInRect(context, CGRectMake(0, 0, w, h));
            
            CGContextRestoreGState(context);
        }
    }
    
    var points: NSArray!;
    
    func setPoints(arr: NSArray) {
        points = arr;
    }
    func draw() {

        var subviews = self.subviews;
        for subview in subviews {
            subview.removeFromSuperview();
        }
        
        // 点を描画
        var pointSize: CGFloat = 10.0;
        for point in points {
            var p = (point as NSValue).CGPointValue();
            p.x = p.x * self.frame.width - (pointSize*0.5);
            p.y = self.frame.height - (p.y * self.frame.height) - (pointSize*0.5);
            self.addSubview(TouchPoint(frame: CGRectMake(p.x, p.y, pointSize, pointSize)));
        }

        // 線を更新
        self.setNeedsDisplay();
    }
    override func drawRect(rect: CGRect) {
        
        var context = UIGraphicsGetCurrentContext();
        
        CGContextClearRect(context, self.frame);
        
        CGContextSaveGState(context);
    
        var line = UIBezierPath();
        UIColor.blackColor().setStroke()
        line.lineWidth = 1;

        // startpoint
        var sp = pointToPosition((points.objectAtIndex(0) as NSValue).CGPointValue());
        line.moveToPoint(CGPointMake(sp.x, sp.y));
        
        // endpoint
        var ep = pointToPosition((points.lastObject as NSValue).CGPointValue());
        line.addLineToPoint(CGPointMake(ep.x, ep.y));
        
        // 描画
        line.stroke();
        
        CGContextRestoreGState(context);
    }
    func pointToPosition(point: CGPoint) -> CGPoint {
        return CGPointMake(point.x * self.frame.width, self.frame.height - (point.y * self.frame.height));
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
    
    @IBOutlet weak var toneCurveView: ToneCurveView!
    var points: NSArray = [NSValue(CGPoint: CGPointMake(0.0, 0.0)), NSValue(CGPoint: CGPointMake(1.0, 1.0))];
    var points_r: NSArray = [NSValue(CGPoint: CGPointMake(0.0, 0.0)), NSValue(CGPoint: CGPointMake(1.0, 1.0))];
    var points_g: NSArray = [NSValue(CGPoint: CGPointMake(0.0, 0.0)), NSValue(CGPoint: CGPointMake(1.0, 1.0))];
    var points_b: NSArray = [NSValue(CGPoint: CGPointMake(0.0, 0.0)), NSValue(CGPoint: CGPointMake(1.0, 1.0))];
    
    func passImageSource(baseImage: UIImage)
    {
        imageSource = baseImage;
        imageNow = ImageProcessing.toneCurveFilter(imageSource, points:points);
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
        toneCurveView.setPoints(points);
        toneCurveView.draw();
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

