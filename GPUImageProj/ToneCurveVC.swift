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
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame);
            backgroundColor = UIColor.clearColor();
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
    
    var points: NSMutableArray!;
    var movePointIndex: Int = 0;
    
    var delegate: ToneCurvePointUpdateDelegate!;

    func initialize(obj: ToneCurvePointUpdateDelegate) {
        
        delegate = obj;
        
        // 長押し
        var longPressGesture = UILongPressGestureRecognizer(target: self, action: "longPressAction:");
        self.addGestureRecognizer(longPressGesture);
        
        // ドラッグ
        var panGesture = UIPanGestureRecognizer(target: self, action: "panAction:");
        self.addGestureRecognizer(panGesture);
    }
    
    func longPressAction(sender: UILongPressGestureRecognizer) {
        
        NSLog("longPress!");
        
        var location = sender.locationInView(self);
        
        if (sender.state == UIGestureRecognizerState.Began)
        {
            points.addObject(NSValue(CGPoint: positionToPoint(location)));
            movePointIndex = points.count-1;
        }
        
        if (sender.state == UIGestureRecognizerState.Ended)
        {
            if let target = delegate {
                target.toneCurvePointUpdate(points);
            }
        }
    }
    func panAction(sender: UIPanGestureRecognizer) {
        
        NSLog("pan!");

        // ドラッグで移動した距離を取得する
        //var distance = sender.translationInView(self.view);
        
        // ポイントを移動
        var p = sender.locationInView(self);
        p.x = max(p.x, 0);
        p.x = min(p.x, self.frame.size.width);
        p.y = max(p.y, 0);
        p.y = min(p.y, self.frame.size.height);
        points[movePointIndex] = NSValue(CGPoint: positionToPoint(p));
        
        // 描画更新
        draw();
        
        // ドラッグで移動した距離を初期化する
        // これを行わないと、[sender translationInView:]が返す距離は、ドラッグが始まってからの蓄積値となるため、
        // 今回のようなドラッグに合わせてImageを動かしたい場合には、蓄積値をゼロにする
        //sender.setTranslation(CGPointZero, inView: self.view);
    }

    func setPoints(arr: NSMutableArray) {
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

        // 描画更新
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
    func positionToPoint(position: CGPoint) -> CGPoint {
        return CGPointMake(self.frame.width / position.x, 1.0 - (self.frame.height / position.y));
    }
}

protocol ToneCurvePointUpdateDelegate
{
    func toneCurvePointUpdate(arr: NSMutableArray);
}
class ToneCurveVC: UIViewController
    , UINavigationControllerDelegate
    , UITextFieldDelegate
    , MainVCDelegate
    , ToneCurvePointUpdateDelegate
{
    var delegate: ToneCurveVCDelegate!;
    
    @IBOutlet weak var preview: UIImageView!
    
    var imageSource: UIImage!;
    var imageNow: UIImage!;
    
    @IBOutlet weak var toneCurveView: ToneCurveView!

    var points: NSMutableArray = [NSValue(CGPoint: CGPointMake(0.0, 0.0)), NSValue(CGPoint: CGPointMake(1.0, 1.0))];
    var points_r: NSMutableArray = [NSValue(CGPoint: CGPointMake(0.0, 0.0)), NSValue(CGPoint: CGPointMake(1.0, 1.0))];
    var points_g: NSMutableArray = [NSValue(CGPoint: CGPointMake(0.0, 0.0)), NSValue(CGPoint: CGPointMake(1.0, 1.0))];
    var points_b: NSMutableArray = [NSValue(CGPoint: CGPointMake(0.0, 0.0)), NSValue(CGPoint: CGPointMake(1.0, 1.0))];
    
    var movingIndex: Int = 0;
    
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
        
        toneCurveView.initialize(self);
        toneCurveViewUpdate();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toneCurvePointUpdate(arr: NSMutableArray) {
        points = arr;
    }
    
    func toneCurveViewUpdate() {
        toneCurveView.setPoints(points);
        toneCurveView.draw();
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

