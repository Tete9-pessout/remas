import 'package:flutter/material.dart'; // استيراد حزمة فلاتر لبناء واجهات المستخدم
import 'package:audioplayers/audioplayers.dart'; // استيراد حزمة لتشغيل الصوت
import 'package:url_launcher/url_launcher.dart' show canLaunchUrl, launchUrl; // استيراد حزمة لفتح الروابط
import 'package:video_player/video_player.dart'; // استيراد حزمة لتشغيل الفيديو

void main() {
  runApp(const SustainabilityApp()); // تشغيل التطبيق
}

class SustainabilityApp extends StatelessWidget {
  const SustainabilityApp({super.key}); // مُنشئ التطبيق

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'اختبار الاستدامة', // عنوان التطبيق
      theme: ThemeData(
        primarySwatch: Colors.blue, // نظام الألوان للتطبيق
        scaffoldBackgroundColor: Colors.blue.shade50, // لون خلفية الشاشة
      ),
      home: const WelcomeScreen(), // الشاشة الرئيسية للتطبيق
    );
  }
}

// شاشة الترحيب
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key}); // مُنشئ شاشة الترحيب

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState(); // إنشاء الحالة لشاشة الترحيب
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late VideoPlayerController _controller; // متحكم الفيديو
  bool _isPlaying = false; // حالة تشغيل الفيديو

  @override
  void initState() {
    super.initState(); // استدعاء الدالة الأصلية
    _controller = VideoPlayerController.asset('assets/s.mp4') // تحميل فيديو من الأصول
      ..initialize().then((_) { // انتظار تحميل الفيديو
        setState(() {}); // تحديث واجهة المستخدم
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // تنظيف المتحكم عند الانتهاء
    super.dispose(); // استدعاء الدالة الأصلية
  }

  void _toggleVideo() { // دالة لتبديل تشغيل الفيديو
    setState(() {
      if (_controller.value.isPlaying) { // إذا كان الفيديو قيد التشغيل
        _controller.pause(); // إيقاف الفيديو
        _isPlaying = false; // تحديث حالة التشغيل
      } else {
        _controller.play(); // تشغيل الفيديو
        _isPlaying = true; // تحديث حالة التشغيل
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مرحبًا بك!'), // عنوان شريط التطبيق
        actions: [
          IconButton(
            icon: const Icon(Icons.share), // زر لمشاركة النتائج
            onPressed: _shareResult, // دالة لمشاركة النتيجة
            tooltip: "مشاركة النتيجة", // تلميح الزر
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView( // محتوى قابل للتمرير
          padding: const EdgeInsets.all(16.0), // هوامش المحتوى
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // محاذاة العمود للوسط
            children: [
              ClipOval( // صورة دائرية
                child: Image.asset(
                  'Images/8.jpg', // مسار الصورة
                  width: 150, // عرض الصورة
                  height: 150, // ارتفاع الصورة
                  fit: BoxFit.cover, // ضبط الصورة لتغطية المساحة
                ),
              ),
              const SizedBox(height: 20), // مسافة بين العناصر
              const Text(
                'الاستدامة هي استخدام الموارد الطبيعية بطريقة تحافظ على توازن البيئة وتضمن استمرارية الأجيال القادمة في العيش بشكل جيد.', // تعريف الاستدامة
                textAlign: TextAlign.center, // توسيط النص
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500), // تنسيق النص
              ),
              const SizedBox(height: 20), // مسافة إضافية
              ElevatedButton( // زر لبدء اللعبة
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue), // إعداد الزر
                onPressed: () { // عند الضغط على الزر
                  Navigator.push( // الانتقال إلى شاشة الاختبار
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SustainabilityQuiz(level: 1), // الانتقال للمستوى 1
                    ),
                  );
                },
                child: const Text('ابدأ اللعبة'), // نص الزر
              ),
              const SizedBox(height: 20), // مسافة إضافية
              _controller.value.isInitialized // التحقق من جاهزية الفيديو
                  ? Column( // إذا كان الفيديو جاهزًا
                    children: [
                      AspectRatio( // الحفاظ على نسبة العرض إلى الارتفاع
                        aspectRatio: _controller.value.aspectRatio, // نسبة العرض
                        child: VideoPlayer(_controller), // عرض الفيديو
                      ),
                      const SizedBox(height: 10), // مسافة بين الفيديو وزر التشغيل
                      ElevatedButton(
                        onPressed: _toggleVideo, // دالة لتبديل تشغيل الفيديو
                        child: Text(
                          _isPlaying ? 'إيقاف الفيديو' : 'تشغيل الفيديو', // نص الزر بناءً على حالة التشغيل
                        ),
                      ),
                    ],
                  )
                  : const CircularProgressIndicator(), // مؤشر تحميل الفيديو إذا لم يكن جاهزًا
              const SizedBox(height: 20), // مسافة إضافية
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareResult() async { // دالة لمشاركة النتيجة
    final String textToShare = "لقد أكملت اختبار الاستدامة! انضم إلي وابدأ الاختبار الآن!"; // النص المراد مشاركته
    final Uri uri = Uri.parse("sms:?body=$textToShare"); // إعداد رابط الرسالة

    try {
      if (await canLaunchUrl(uri)) { // التحقق من إمكانية فتح الرابط
        await launchUrl(uri); // فتح الرابط
      } else {
        throw 'لا يمكن فتح الرابط'; // رسالة خطأ في حالة عدم القدرة على فتح الرابط
      }
    } catch (e) {
      print("خطأ: $e"); // طباعة أي أخطاء تحدث
    }
  }
}

// شاشة الأسئلة
class SustainabilityQuiz extends StatefulWidget {
  final int level; // مستوى الاختبار
  const SustainabilityQuiz({super.key, required this.level}); // مُنشئ شاشة الأسئلة

  @override
  SustainabilityQuizState createState() => SustainabilityQuizState(); // إنشاء حالة الشاشة
}

class SustainabilityQuizState extends State<SustainabilityQuiz> {
  int score = 0; // النقاط المكتسبة
  int currentQuestionIndex = 0; // مؤشر السؤال الحالي
  final AudioPlayer audioPlayer = AudioPlayer(); // مُشغل الصوت

  // قائمة الأسئلة بحسب المستوى
  final List<List<Map<String, dynamic>>> questionsByLevel = [
    [],
    [
      {
        'question': 'ما هو مفهوم الاستدامة؟', // السؤال الأول
        'answers': [ // خيارات الإجابات
          'حماية البيئة',
          'استهلاك كل الموارد',
          'تجاهل التلوث',
          'لا شيء مما سبق',
        ],
        'correctAnswer': 'حماية البيئة', // الإجابة الصحيحة
      },
      {
        'question': 'أي من هذه المصادر متجدد؟', // السؤال الثاني
        'answers': ['الطاقة الشمسية', 'الفحم', 'الغاز الطبيعي', 'النفط'], // خيارات الإجابات
        'correctAnswer': 'الطاقة الشمسية', // الإجابة الصحيحة
      },
      {
        'question': 'ما هو تأثير الاستدامة على المجتمع؟', // السؤال الثالث
        'answers': [
          'تحسين الصحة',
          'تدمير البيئات',
          'زيادة التلوث',
          'لا شيء مما سبق',
        ],
        'correctAnswer': 'تحسين الصحة', // الإجابة الصحيحة
      },
      {
        'question': 'ما هي الطاقة المتجددة؟', // السؤال الرابع
        'answers': ['الطاقة الشمسية', 'النفط', 'الفحم', 'الغاز الطبيعي'], // خيارات الإجابات
        'correctAnswer': 'الطاقة الشمسية', // الإجابة الصحيحة
      },
    ],
    [
      {
        'question': 'ما هو تأثير الطاقة المتجددة على البيئة؟', // السؤال الأول لمستوى 2
        'answers': [
          'تقليل الانبعاثات الكربونية',
          'زيادة التلوث',
          'تدمير المحيطات',
          'لا شيء مما سبق',
        ],
        'correctAnswer': 'تقليل الانبعاثات الكربونية', // الإجابة الصحيحة
      },
      {
        'question': 'ما هي أحد أضرار إزالة الغابات؟', // السؤال الثاني لمستوى 2
        'answers': [
          'تدمير المواطن',
          'زيادة المساحات الزراعية',
          'زيادة التنوع البيولوجي',
          'لا شيء مما سبق',
        ],
        'correctAnswer': 'تدمير المواطن', // الإجابة الصحيحة
      },
      {
        'question': 'أي من هذه الموارد غير متجددة؟', // السؤال الثالث لمستوى 2
        'answers': ['الفحم', 'الطاقة الشمسية', 'الرياح', 'المياه'], // خيارات الإجابات
        'correctAnswer': 'الفحم', // الإجابة الصحيحة
      },
      {
        'question': 'كيف يمكننا الحفاظ على المياه؟', // السؤال الرابع لمستوى 2
        'answers': [
          'إعادة تدوير المياه',
          'استخدام المياه بكثرة',
          'التخلص من المياه الملوثة',
          'لا شيء مما سبق',
        ],
        'correctAnswer': 'إعادة تدوير المياه', // الإجابة الصحيحة
      },
    ],
    [
      {
        'question': 'ما هو تأثير الاستدامة على الاقتصاد؟', // السؤال الأول لمستوى 3
        'answers': [
          'تحسين الكفاءة الاقتصادية',
          'زيادة التكاليف',
          'تقليل الاستثمارات',
          'لا شيء مما سبق',
        ],
        'correctAnswer': 'تحسين الكفاءة الاقتصادية', // الإجابة الصحيحة
      },
      {
        'question': 'ما هو مفهوم الزراعة المستدامة؟', // السؤال الثاني لمستوى 3
        'answers': [
          'استخدام تقنيات زراعية حديثة',
          'إزالة الغابات من أجل الزراعة',
          'استخدام المبيدات بشكل مكثف',
          'لا شيء مما سبق',
        ],
        'correctAnswer': 'استخدام تقنيات زراعية حديثة', // الإجابة الصحيحة
      },
      {
        'question': 'ما هي تأثيرات المواد البلاستيكية على البيئة؟', // السؤال الثالث لمستوى 3
        'answers': [
          'تلوث المحيطات',
          'زيادة التنوع البيولوجي',
          'تحسين التربة',
          'لا شيء مما سبق',
        ],
        'correctAnswer': 'تلوث المحيطات', // الإجابة الصحيحة
      },
      {
        'question': 'كيف نحد من تأثير التلوث؟', // السؤال الرابع لمستوى 3
        'answers': [
          'استخدام وسائل النقل العام',
          'استخدام السيارات الخاصة بكثرة',
          'زيادة الصناعات',
          'لا شيء مما سبق',
        ],
        'correctAnswer': 'استخدام وسائل النقل العام', // الإجابة الصحيحة
      },
    ],
    [
      {
        'question': 'ما هي الطاقة المتجددة الأكثر فعالية؟', // السؤال الأول لمستوى 4
        'answers': [
          'الطاقة الشمسية',
          'الطاقة الريحية',
          'الطاقة النووية',
          'لا شيء مما سبق',
        ],
        'correctAnswer': 'الطاقة الشمسية', // الإجابة الصحيحة
      },
      {
        'question': 'ما هو تأثير تغيير المناخ على النظم البيئية؟', // السؤال الثاني لمستوى 4
        'answers': [
          'زيادة التنوع البيولوجي',
          'انقراض بعض الأنواع',
          'زيادة الأشجار',
          'لا شيء مما سبق',
        ],
        'correctAnswer': 'انقراض بعض الأنواع', // الإجابة الصحيحة
      },
      {
        'question': 'كيف تؤثر الاستدامة على الطاقة؟', // السؤال الثالث لمستوى 4
        'answers': [
          'تقلل من استهلاك الطاقة',
          'تزيد من إنتاج الطاقة',
          'تتجاهل الطاقة',
          'لا شيء مما سبق',
        ],
        'correctAnswer': 'تقلل من استهلاك الطاقة', // الإجابة الصحيحة
      },
      {
        'question': 'ما هي الحلول لاستدامة الغذاء؟', // السؤال الرابع لمستوى 4
        'answers': [
          'استخدام الزراعة العضوية',
          'استهلاك كميات أكبر من اللحوم',
          'زيادة استهلاك المواد البلاستيكية',
          'لا شيء مما سبق',
        ],
        'correctAnswer': 'استخدام الزراعة العضوية', // الإجابة الصحيحة
      },
    ],
    [
      {
        'question': 'ما هو تأثير الاستدامة على المدن؟', // السؤال الأول لمستوى 5
        'answers': [
          'تحسين نوعية الحياة',
          'زيادة التلوث',
          'زيادة التوسع العمراني',
          'لا شيء مما سبق',
        ],
        'correctAnswer': 'تحسين نوعية الحياة', // الإجابة الصحيحة
      },
      {
        'question': 'كيف يمكن تقليل الفاقد في الطعام؟', // السؤال الثاني لمستوى 5
        'answers': [
          'تحسين إدارة المخزون',
          'شراء كميات أكبر من الطعام',
          'استخدام الكثير من المواد البلاستيكية',
          'لا شيء مما سبق',
        ],
        'correctAnswer': 'تحسين إدارة المخزون', // الإجابة الصحيحة
      },
      {
        'question': 'ما هي تقنية الطاقة المتجددة الأكثر استخدامًا؟', // السؤال الثالث لمستوى 5
        'answers': [
          'الألواح الشمسية',
          'التوربينات الريحية',
          'الطاقة الكهرومائية',
          'لا شيء مما سبق',
        ],
        'correctAnswer': 'الألواح الشمسية', // الإجابة الصحيحة
      },
      {
        'question': 'كيف نحقق الاستدامة في مجال السياحة؟', // السؤال الرابع لمستوى 5
        'answers': [
          'السياحة البيئية',
          'زيادة التلوث',
          'إلغاء المعالم السياحية',
          'لا شيء مما سبق',
        ],
        'correctAnswer': 'السياحة البيئية', // الإجابة الصحيحة
      },
    ],
    [
      {
        'question': 'ما هو دور الفرد في تحقيق الاستدامة؟', // السؤال الأول لمستوى 6
        'answers': [
          'تقليل الاستهلاك',
          'زيادة التلوث',
          'استهلاك الموارد بكثرة',
          'لا شيء مما سبق',
        ],
        'correctAnswer': 'تقليل الاستهلاك', // الإجابة الصحيحة
      },
      {
        'question': 'ما هي فوائد الطاقة المتجددة؟', // السؤال الثاني لمستوى 6
        'answers': [
          'توفير الطاقة',
          'زيادة انبعاثات الغازات الدفيئة',
          'التلوث',
          'لا شيء مما سبق',
        ],
        'correctAnswer': 'توفير الطاقة', // الإجابة الصحيحة
      },
      {
        'question': 'كيف نساهم في تقليل النفايات؟', // السؤال الثالث لمستوى 6
        'answers': [
          'إعادة التدوير',
          'زيادة استهلاك البلاستيك',
          'إلقاء النفايات في الطبيعة',
          'لا شيء مما سبق',
        ],
        'correctAnswer': 'إعادة التدوير', // الإجابة الصحيحة
      },
      {
        'question': 'ما هي أكثر أنواع التلوث انتشارًا؟', // السؤال الرابع لمستوى 6
        'answers': ['تلوث الهواء', 'تلوث المياه', 'تلوث الأرض', 'كل ما سبق'], // خيارات الإجابات
        'correctAnswer': 'كل ما سبق', // الإجابة الصحيحة
      },
    ],
  ];

  void checkAnswer(String answer) { // دالة للتحقق من الإجابات
    var correctAnswer = questionsByLevel[widget.level][currentQuestionIndex]['correctAnswer']; // الإجابة الصحيحة
    if (answer == correctAnswer) { // إذا كانت الإجابة صحيحة
      score++; // زيادة النقاط
      audioPlayer.play(AssetSource('sounds/correct_answer.mp3')); // تشغيل صوت صحيح
    } else {
      audioPlayer.play(AssetSource('sounds/wrong_answer.mp3')); // تشغيل صوت خطأ
    }

    if (currentQuestionIndex < questionsByLevel[widget.level].length - 1) { // إذا كان هناك المزيد من الأسئلة
      setState(() {
        currentQuestionIndex++; // الانتقال للسؤال التالي
      });
    } else {
      showResult(); // عرض النتيجة النهائية
    }
  }

  void showResult() { // دالة لعرض النتيجة
    String message = 'لقد أجبت على $score من أصل ${questionsByLevel[widget.level].length} سؤالًا بشكل صحيح.'; // رسالة النتيجة

    Widget nextScreen; // الشاشة التالية بعد النتيجة
    if (widget.level < 6) { // إذا كان هناك مستويات أخرى
      nextScreen = SustainabilityQuiz(level: widget.level + 1); // الانتقال للمستوى التالي
    } else {
      nextScreen = const FinalScreen(); // الانتقال للشاشة النهائية
    }

    showDialog( // عرض مربع حوار بالنتيجة
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('النتيجة'), // عنوان مربع الحوار
          content: Text(message), // محتوى مربع الحوار
          actions: <Widget>[
            TextButton(
              onPressed: () { // عند الضغط على الزر
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => nextScreen), // الانتقال للشاشة التالية
                );
              },
              child: const Text('التالي'), // نص الزر
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var question = questionsByLevel[widget.level][currentQuestionIndex]; // الحصول على السؤال الحالي

    return Scaffold(
      appBar: AppBar(title: Text('مستوى ${widget.level}')), // عنوان التطبيق بمستوى الاختبار
      body: Padding(
        padding: const EdgeInsets.all(16.0), // هوامش المحتوى
        child: Column( // عمود لعرض المحتوى
          mainAxisAlignment: MainAxisAlignment.center, // محاذاة العمود في المنتصف
          children: [
            Text(question['question'], style: const TextStyle(fontSize: 24)), // عرض السؤال الحالي
            const SizedBox(height: 20), // مسافة بين السؤال والأزرار
            for (var answer in question['answers']) // جملة لتوليد أزرار الإجابات
              ElevatedButton( // زر للإجابة
                onPressed: () => checkAnswer(answer), // التحقق من الإجابة عند الضغط
                child: Text(answer), // نص الزر
              ),
          ],
        ),
      ),
    );
  }
}

// الشاشة النهائية
class FinalScreen extends StatelessWidget {
  const FinalScreen({super.key}); // مُنشئ الشاشة النهائية

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('النتيجة النهائية')), // عنوان الشاشة النهائية
      body: Center(
        child: Column( // عمود لعرض المحتوى
          mainAxisAlignment: MainAxisAlignment.center, // محاذاة المحتوى في المنتصف
          children: [
            const Text(
              'مبروك! لقد أكملت جميع المستويات!', // رسالة الشكر
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // تنسيق النص
            ),
            const SizedBox(height: 20), // مسافة بين العناصر
            ElevatedButton( // زر للعودة إلى الشاشة الرئيسية
              onPressed: () { 
                // العودة إلى الصفحة الأولى
                Navigator.pushReplacement( // استبدال الشاشة الحالية بالشاشة الرئيسية
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeScreen(), // الانتقال إلى شاشة الترحيب
                  ),
                );
              },
              child: const Text('العودة إلى الصفحة الرئيسية'), // نص الزر
            ),
          ],
        ),
      ),
    );
  }
}