import UIKit
import CoreImage
import GPUImage

class ImageProcessing
{
    // フォーカスぼかし
    class func focusBlurFilter(baseImage: UIImage
        , radius: CGFloat
        , point: CGPoint
        ) -> UIImage
    {
        var filter = GPUImageGaussianSelectiveBlurFilter();
        filter.excludeCircleRadius = radius;
        filter.excludeCirclePoint = point;
        return filter.imageByFilteringImage(baseImage);
    }
    
    //
    // Color adjustments
    //
    
    // 輝度
    class func brightnessFilter(baseImage: UIImage
        , brightness: CGFloat
        ) -> UIImage
    {
        // brightness : -1.0 ~ 1.0
        var filter = GPUImageBrightnessFilter();
        filter.brightness = brightness;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 露出(ISO)
    class func exposureFilter(baseImage: UIImage
        , exposure: CGFloat
        ) -> UIImage
    {
        // exposure : -10.0 ~ 10.0
        var filter = GPUImageExposureFilter();
        filter.exposure = exposure;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // コントラスト
    class func contrastFilter(baseImage: UIImage
        , contrast: CGFloat
        ) -> UIImage
    {
        // contrast : 0.0 ~ 4.0
        var filter = GPUImageContrastFilter();
        filter.contrast = contrast;
        return filter.imageByFilteringImage(baseImage);
    }

    // ガンマ値
    class func gammaFilter(baseImage: UIImage
        , gamma: CGFloat
        ) -> UIImage
    {
        // gamma : 0.0 ~ 3.0
        var filter = GPUImageGammaFilter();
        filter.gamma = gamma;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // カラーマトリクス変換
    class func colorMatrixFilter(baseImage: UIImage
        , matrix: GPUMatrix4x4
        , intensity: CGFloat
        ) -> UIImage
    {
        // GPUMatrix4x4(one: GPUVector4(one: GLfloat, two: GLfloat, three: GLfloat, four: GLfloat), two: GPUVector4, three: GPUVector4, four: GPUVector4);
        
        // colorMatrix : GPUMatrix4x4 画像の各色を変換するために使用
        // intensity : 新たに形質転換色各画素の元の色を置き換える度合い
        var filter = GPUImageColorMatrixFilter();
        filter.colorMatrix = matrix;
        filter.intensity = intensity;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // RGB調整
    class func rgbFilter(baseImage: UIImage
        , red: CGFloat
        , green: CGFloat
        , blue: CGFloat
        ) -> UIImage
    {
        // red,green,blue : 0.0 ~ 1.0
        var filter = GPUImageRGBFilter();
        filter.red = red;
        filter.green = green;
        filter.blue = blue;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 色相変換 角度で指定(180.0で逆になる？)
    class func hueFilter(baseImage: UIImage
        , hue: CGFloat
        ) -> UIImage
    {
        // red,green,blue : 0.0 ~ 1.0
        var filter = GPUImageHueFilter();
        filter.hue = hue;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // トーンカーブ
    class func toneCurveFilter(baseImage: UIImage
        , redPoints: NSArray
        , greenPoints: NSArray
        , bluePoints: NSArray
        ) -> UIImage
    {
        // redPoints,greenPoints,bluePoints : NSArray from CGPoint
        // CGPoint : (0.0, 0.0) ~ (1.0, 1.0)
        // NSArray Default : [(0.0, 0.0), (0.5, 0.5), (1.0, 1.0)]
        var filter = GPUImageToneCurveFilter();
        filter.redControlPoints = redPoints;
        filter.greenControlPoints = greenPoints;
        filter.blueControlPoints = bluePoints;
        return filter.imageByFilteringImage(baseImage);
    }

    // ハイライト調整
    class func highlightShadowFilter(baseImage: UIImage
        , shadows: CGFloat
        , highlights: CGFloat
        ) -> UIImage
    {
        // shadows : 0.0 ~ 1.0 Default 0.0
        // highlights : 0.0 ~ 1.0 Default 1.0
        var filter = GPUImageHighlightShadowFilter();
        filter.shadows = shadows;
        filter.highlights = highlights;
        return filter.imageByFilteringImage(baseImage);
    }

    // 色反転
    class func colorInvertFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageColorInvertFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // グレースケール変換
    class func grayscaleFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageGrayscaleFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 単色変換
    class func falseColorFilter(baseImage: UIImage
        , firstColor: GPUVector4
        , secondColor: GPUVector4
        ) -> UIImage
    {
        // 各画素の輝度に基づいて、単色バージョンに画像を変換する
        // firstColor, secondColor : GPUVector4(one: GLfloat, two: GLfloat, three: GLfloat, four: GLfloat)
        var filter = GPUImageFalseColorFilter();
        filter.firstColor = firstColor;
        filter.secondColor = secondColor;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // セピア
    class func sepiaFilter(baseImage: UIImage
        , intensity: CGFloat
        ) -> UIImage
    {
        // intensity : 0.0 ~ 1.0
        var filter = GPUImageSepiaFilter();
        filter.intensity = intensity;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // アルファチャンネル調整
    class func opacityFilter(baseImage: UIImage
        , opacity: CGFloat
        ) -> UIImage
    {
        // opacity : 0.0 ~ 1.0
        var filter = GPUImageOpacityFilter();
        filter.opacity = opacity;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 輝度による2値化
    class func luminanceThresholdFilter(baseImage: UIImage
        , threshold: CGFloat
        ) -> UIImage
    {
        // threshold : 0.0 ~ 1.0 Default 0.5
        var filter = GPUImageLuminanceThresholdFilter();
        filter.threshold = threshold;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 平均輝度による2値化
    class func averageLuminanceThresholdFilter(baseImage: UIImage
        , thresholdMultiplier: CGFloat
        ) -> UIImage
    {
        // これは、閾値が継続的にシーンの平均輝度に基づいて調整される閾値化操作を適用する
        // threshold : 0.0 ~ 1.0 Default 0.5
        var filter = GPUImageAverageLuminanceThresholdFilter();
        filter.thresholdMultiplier = thresholdMultiplier;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 不明
    class func chromaKeyFilter(baseImage: UIImage
        , thresholdSensitivity: CGFloat
        , smoothing: CGFloat
        ) -> UIImage
    {
        // 画像内の指定された色については、これはGPUImageChromaKeyBlendFilterに類似して0にするアルファチャンネルを設定するだけの代わりに、
        // これは単に第二の画像を取り込むとしないマッチング色について第二の画像にブレンディングの所与の色を透明に変わり。
        // thresholdSensitivity : Default 0.4
        // smoothing : Default 0.1
        var filter = GPUImageChromaKeyFilter();
        filter.thresholdSensitivity = thresholdSensitivity;
        filter.smoothing = smoothing;
        return filter.imageByFilteringImage(baseImage);
    }


    //
    // Image processing
    //
    
    // 2D変形
    class func transformFilter(baseImage: UIImage
        , transform: CGAffineTransform
        , ignoreAspectRatio: Bool
        ) -> UIImage
    {
        // パラメータ例
        //var t: CGAffineTransform;
        //t = CGAffineTransformMakeScale(0.75, 0.75); //　縮小
        //t = CGAffineTransformTranslate(t, 0, 0.5);  // 移動
        
        var filter = GPUImageTransformFilter();
        filter.affineTransform = transform;
        filter.ignoreAspectRatio = ignoreAspectRatio;
        return filter.imageByFilteringImage(baseImage);
    }

    // 3D変形
    class func transformFilter(baseImage: UIImage
        , transform: CATransform3D
        , ignoreAspectRatio: Bool
        ) -> UIImage
    {
        // パラメータ例
        //var t = CATransform3DIdentity;
        //t.m34 = 0.4;
        //t.m33 = 0.4;
        //t = CATransform3DRotate(t, 0.75, 1.0, 0.0, 0.0);

        var filter = GPUImageTransformFilter();
        filter.transform3D = transform;
        filter.ignoreAspectRatio = ignoreAspectRatio;
        return filter.imageByFilteringImage(baseImage);
    }

    // クリッピング
    class func cropFilter(baseImage: UIImage
        , cropRegion: CGRect
        ) -> UIImage
    {
        var filter = GPUImageCropFilter();
        filter.cropRegion = cropRegion;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // ダウンサンプリング
    class func lanczosResamplingFilter(baseImage:UIImage) -> UIImage
    {
        var filter = GPUImageLanczosResamplingFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // シャープネス
    class func sharpenFilter(baseImage: UIImage
        , sharpness: CGFloat
        ) -> UIImage
    {
        var filter = GPUImageSharpenFilter();
        filter.sharpness = sharpness;
        return filter.imageByFilteringImage(baseImage);
    }

    // アンシャープマスク
    class func unsharpMaskFilter(baseImage: UIImage
        , blurSize: CGFloat
        , intensity: CGFloat
        ) -> UIImage
    {
        // blurRadiusInPixels : 0.0 ~ Default 1.0
        // intensity : 0.0 ~ Default 1.0
        var filter = GPUImageUnsharpMaskFilter();
        filter.blurRadiusInPixels = blurSize;
        filter.intensity = intensity;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // ガウスぼかし
    class func gaussianBlurFilter(baseImage: UIImage
        , blurSize: CGFloat
        ) -> UIImage
    {
        // blurSize : 0.0 ~ Default 1.0
        var filter = GPUImageGaussianBlurFilter();
        filter.blurRadiusInPixels = blurSize;
        return filter.imageByFilteringImage(baseImage);
    }
 
    // 円形フォーカス的ぼかし
    class func gaussianSelectiveBlurFilter(baseImage: UIImage
        , blurSize: CGFloat
        , radius: CGFloat
        , point: CGPoint
        , exBlurSize: CGFloat
        , aspectRatio: CGFloat
        ) -> UIImage
    {
        // blurSize : 0.0 ~ Defalut 1.0 ぼかし強度
        // radius : 0.0 ~ 1.0 ぼかし除外(フォーカス)半径
        // point : (0.0, 0.0) ~ (1.0, 1.0) ぼかし除外(フォーカス)円の中心位置
        // exBlurSize : 0.0 ~ フォーカス範囲とぼかし範囲の境界をどれくらいの幅にするか
        // aspectRatio : Default 1.0 円の歪み(0.0だと縦長？よくわからない)
        var filter = GPUImageGaussianSelectiveBlurFilter();
        filter.blurRadiusInPixels = blurSize;
        filter.excludeCircleRadius = radius;
        filter.excludeCirclePoint = point;
        filter.excludeBlurSize = exBlurSize;
        filter.aspectRatio = aspectRatio;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // チルトシフト(上下ぼかし)
    class func tiltShiftFilter(baseImage: UIImage
        , blurSize: CGFloat
        , topFocusLevel: CGFloat
        , bottomFocusLevel: CGFloat
        , focusFallOffRate: CGFloat
        ) -> UIImage
    {
        // blurSize : 0.0 ~ Default 2.0
        // topFocusLevel : Default 0.4 焦点領域上部 bottomFocusLeveより低く設定
        // bottomFocusLevel : Default 0.6 焦点領域下部 topFocusLevelより高く設定
        // focusFallOffRate : Default 0.2 画像が合焦領域から離れてぼやけを取得する速度(?)
        var filter = GPUImageTiltShiftFilter();
        filter.blurRadiusInPixels = blurSize;
        filter.topFocusLevel = topFocusLevel;
        filter.bottomFocusLevel = bottomFocusLevel;
        filter.focusFallOffRate = focusFallOffRate;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 平滑化ぼかし?
    class func boxBlurFilter(baseImage :UIImage, blurSize: CGFloat) -> UIImage
    {
        var filter = GPUImageBoxBlurFilter();
        filter.blurRadiusInPixels = blurSize;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 画像に対して3x3の畳み込みカーネルを実行します(?)
    class func Convolution3x3Filter(baseImage: UIImage
        , kernel: GPUMatrix3x3
        ) -> UIImage
    {
        // 畳み込みカーネルは、ピクセルとその周囲8画素に適用する値の3×3行列である。
        // 行列は、左上ピクセルの幸福のone.oneと右下のthree.threeで、行優先順に指定されている。
        // 行列の値が1.0にならない場合は、イメージが明るくまたは暗くすることができた。
        // kernel : GPUMatrix3x3(one: GPUVector3, two: GPUVector3, three: GPUVector3);
        var filter = GPUImage3x3ConvolutionFilter();
        filter.convolutionKernel = kernel;
        return filter.imageByFilteringImage(baseImage);
    }

    // ゾーベルエッジ検出白強調
    class func sobelEdgeDetectionFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageSobelEdgeDetectionFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    class func sobelEdgeDetectionFilter(baseImage: UIImage
        , texelWidth: CGFloat
        , texelHeight: CGFloat
        ) -> UIImage
    {
        // texelWidth : 0.01くらいが丁度いい
        // texelHeight : 0.01くらいが丁度いい
        var filter = GPUImageSobelEdgeDetectionFilter();
        filter.texelWidth = texelWidth;
        filter.texelHeight = texelHeight;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // キャニー法エッジ検出白強調
    class func cannyEdgeDetectionFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageCannyEdgeDetectionFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    class func cannyEdgeDetectionFilter(baseImage: UIImage
        , texelWidth: CGFloat
        , texelHeight: CGFloat
        , blurSize: CGFloat
        , upperThreshold: CGFloat
        , lowerThreshold: CGFloat
        ) -> UIImage
    {
        // texelWidth : 0.001くらいが丁度いい
        // texelHeight : 0.001くらいが丁度いい
        // blurSize: 0.0 ~ Default 1.0 検出前にぼかす度合い
        // upperThreshold : Default 0.4 エッジとして検出する閾値
        // lowerThreshold : Default 0.1 エッジとして検出しない閾値
        
        var filter = GPUImageCannyEdgeDetectionFilter();
        filter.texelWidth = texelWidth;
        filter.texelHeight = texelHeight;
        filter.blurRadiusInPixels = blurSize;
        filter.upperThreshold = upperThreshold;
        filter.lowerThreshold = lowerThreshold;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 頂点検出Harris法
    class func harrisCornerDetectionFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageHarrisCornerDetectionFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    class func harrisCornerDetectionFilter(baseImage: UIImage
        , blurSize: CGFloat
        , sensitivity: CGFloat
        , threshold: CGFloat
        ) -> UIImage
    {
        // blurSize : Default 1.0 コーナー検出の実装の一部として適用されるぼかしの相対的な大きさ
        // sensitivity : Default 5.0 内部スケーリング係数は、フィルタで生成cornernessマップのダイナミックレンジを調整するために適用
        // threshold : コーナーとして検出される閾値。
        var filter = GPUImageHarrisCornerDetectionFilter();
        filter.blurRadiusInPixels = blurSize;
        filter.sensitivity = sensitivity;
        filter.threshold = threshold;
        return filter.imageByFilteringImage(baseImage);
    }
 
    // 頂点検出 Noble法
    class func nobleCornerDetectionFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageNobleCornerDetectionFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    class func nobleCornerDetectionFilter(baseImage: UIImage
        , blurSize: CGFloat
        , sensitivity: CGFloat
        , threshold: CGFloat
        ) -> UIImage
    {
        // blurSize : Default 1.0 コーナー検出の実装の一部として適用されるぼかしの相対的な大きさ
        // sensitivity : Default 5.0 内部スケーリング係数は、フィルタで生成cornernessマップのダイナミックレンジを調整するために適用
        // threshold : コーナーとして検出される閾値。
        var filter = GPUImageNobleCornerDetectionFilter();
        filter.blurRadiusInPixels = blurSize;
        filter.sensitivity = sensitivity;
        filter.threshold = threshold;
        return filter.imageByFilteringImage(baseImage);
    }

    // 頂点検出 ShiTomasi法
    class func shiTomasiFeatureDetectionFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageShiTomasiFeatureDetectionFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    class func shiTomasiFeatureDetectionFilter(baseImage: UIImage
        , blurSize: CGFloat
        , sensitivity: CGFloat
        , threshold: CGFloat
        ) -> UIImage
    {
        // blurSize : Default 1.0 コーナー検出の実装の一部として適用されるぼかしの相対的な大きさ
        // sensitivity : Default 5.0 内部スケーリング係数は、フィルタで生成cornernessマップのダイナミックレンジを調整するために適用
        // threshold : コーナーとして検出される閾値。
        var filter = GPUImageShiTomasiFeatureDetectionFilter();
        filter.blurRadiusInPixels = blurSize;
        filter.sensitivity = sensitivity;
        filter.threshold = threshold;
        return filter.imageByFilteringImage(baseImage);
    }

    // ハリスのコーナー検出フィルタの一部として使用される(で、どういう効果なの？)
    class func nonMaximumSuppressionFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageNonMaximumSuppressionFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // ハリスのコーナー検出フィルタの一部として使用される(で、どういう効果なの？)
    // 使ってみたら、青背景に赤と水色で輪郭線が浮き出てきたけど。。。
    class func xyDerivativeFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageXYDerivativeFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 十字ジェネレータ？これはこのまま動かない
    class func crosshairGenerator(baseImage: UIImage
        , crosshairWidth: CGFloat
        ) -> UIImage
    {
        var filter = GPUImageCrosshairGenerator();
        filter.crosshairWidth = crosshairWidth;
        return filter.imageByFilteringImage(baseImage);
    }

    // 拡張フィルタ?(使ってみたらグレースケールっぽい画像になったけど。。。)
    // 何度か繰り返し適用したら、重なりのあるドット絵みたいになった！
    class func dilationFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageDilationFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 全てのカラーチャンネルに作用する拡張フィルタ?(使ってみたら何が変わったかかわからない画像になったけど。。。)
    // 何度か繰り返し適用したら、重なりのあるドット絵みたいになった！
    class func rgbDilationFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageRGBDilationFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 侵食フィルタ?(使ってみたらグレースケールっぽい画像になったけど。。。)
    // 何度か繰り返し適用したら、油絵的な感じに滲んだ！
    class func erosionFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageErosionFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 全てのカラーチャンネルに作用する侵食フィルタ?(使ってみたら何が変わったかかわからない画像になったけど。。。)
    // 何度か繰り返し適用したら、油絵的な感じに滲んだ！
    class func rgbErosionFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageRGBErosionFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // これは、同じ半径の膨張が続く画像の赤チャンネル、上の浸食を実行します。半径1-4画素の範囲で、初期化時に設定されている。
    // (使ってみたらグレースケールっぽい画像になったけど。。。)
    class func openingFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageOpeningFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 赤チャネル、すべてのカラーチャンネルに作用することを除いて、GPUImageOpeningFilterと同じである。
    // (使ってみたら何が変わったかかわからない画像になったけど。。。)
    class func rgbOpeningFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageRGBOpeningFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // これは、同じ半径の侵食に続く画像の赤チャンネルに拡張を行う?
    // (使ってみたらグレースケールっぽい画像になったけど。。。)
    class func closingFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageClosingFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 赤チャネル、すべてのカラーチャンネルに作用することを除いて、GPUImageClosingFilterと同じである。
    // (使ってみたら何が変わったかかわからない画像になったけど。。。)
    class func rgbClosingFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageRGBClosingFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // ローパスフィルタ
    class func lowPassFilter(baseImage: UIImage
        , filterStrength: CGFloat
        ) -> UIImage
    {
        // filterStrength : 0.0 ~ 1.0 Default 0.5
        var filter = GPUImageLowPassFilter();
        filter.filterStrength = filterStrength;
        return filter.imageByFilteringImage(baseImage);
    }

    // ハイパスフィルタ
    class func highPassFilter(baseImage: UIImage
        , filterStrength: CGFloat
        ) -> UIImage
    {
        // filterStrength : 0.0 ~ 1.0 Default 0.5
        var filter = GPUImageHighPassFilter();
        filter.filterStrength = filterStrength;
        return filter.imageByFilteringImage(baseImage);
    }

    // 動き検出器?(使ってみたら、動きのないところが白く、動きのあるところ[滝とか]が水色〜ピンクになった)
    class func motionDetector(baseImage: UIImage
        , lowPassFilterStrength: CGFloat
        ) -> UIImage
    {
        // lowPassFilterStrength : 0.0 ~ 1.0 Default 0.5
        var filter = GPUImageMotionDetector();
        filter.lowPassFilterStrength = lowPassFilterStrength;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 選択的に第二の画像と最初の画像の色を置き換える
    // 同じ画像で片方に他のフィルタかけたものを使うと面白い
    class func chromaKeyBlendFilter(baseImage: UIImage
        , overlayImage: UIImage
        , thresholdSensitivity: CGFloat
        , smoothing: CGFloat
        ) -> UIImage
    {
        // thresholdSensitivity : Default 0.4 どれだけの近さを対象にするか
        // smoothing : Default 0.1 どのくらいスムーズに色変えするか
        var filter = GPUImageChromaKeyBlendFilter();
        filter.thresholdSensitivity = thresholdSensitivity;
        filter.smoothing = smoothing;
        
        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);

        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);

        inputPicture.processImage();
        overlayPicture.processImage();
        
        filter.useNextFrameForImageCapture();
        
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }

}

