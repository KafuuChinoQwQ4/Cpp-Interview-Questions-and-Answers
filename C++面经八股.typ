#set page(
  paper: "a4",
  margin: (top: 21mm, bottom: 18mm, left: 20mm, right: 20mm),
  header: context [
    #align(right)[#text("C++面经八股", size: 8pt, fill: rgb("#687783"))]
  ],
  footer: context [
    #align(center)[#text[面试速答版 · #counter(page).display() / #counter(page).final().first()]]
  ],
)
#set text(font: "Noto Sans CJK SC", size: 10pt, lang: "zh", fill: rgb("#243442"))
#show raw: set text(font: "Noto Sans Mono CJK SC")
#set par(justify: true, leading: 0.68em, spacing: 0.55em)
#set heading(numbering: none)

#align(center)[#text("C++面经八股", size: 25pt, weight: "bold", fill: rgb("#174B66"))]
#v(0.45em)
#align(center)[#text("555 道分类面试题与速记答案", size: 10pt, fill: rgb("#687783"))]
#v(1.15em)
#block(width: 100%, fill: rgb("#F1F6F8"), inset: 9pt, radius: 3pt)[#text("全文按主题分类整理，答案突出核心概念、适用场景和常见边界；带注释的伪代码用于解释关键原理、分支和边界，C++ 标准库名称均使用完整的 std:: 限定；参考文献列于文末。", size: 9.5pt)]
#pagebreak()
#align(center)[#text("目 录", size: 14pt, weight: "medium", fill: rgb("#000000"))]
#v(1em)
#set outline(indent: 1.35em, title: none, depth: 2)
#set outline.entry(fill: repeat([·], gap: 0.36em))
#show outline.entry: it => {
  let entry_size = if it.level == 1 { 9pt } else { 8.5pt }
  let entry_weight = if it.level == 1 { "medium" } else { "regular" }
  let entry_spacing = if it.level == 1 { 0.28em } else { 0.12em }
  block(above: entry_spacing)[
    #link(it.element.location(), it.indented(it.prefix(), {
      show text: set text(fill: rgb("#000000"), size: entry_size, weight: entry_weight)
      it.inner()
    }))
  ]
}
#outline()
#pagebreak()
#heading(level: 1, outlined: true)[#text("第1章 C++ 基础与面向对象", size: 15pt, weight: "bold", fill: rgb("#000000"))]
#heading(level: 2, outlined: true)[#text("1.1 类、接口与多态", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  C++ 中如何使用友元函数（Friend Function）？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  友元函数不是类的成员，但经类内 friend 声明后，可以访问该类的私有和受保护成员。它常用于需要左右操作数对称的运算符，例如让 operator<< 同时访问流和对象；类本身仍须显式授权。友元会扩大访问范围，应限于紧密协作的少数接口，避免破坏封装。", size: 9.5pt)
  #raw("#include <ostream>\nclass Money {\n  friend std::ostream& operator<<(std::ostream&, const Money&); // 类内明确授权\n  int cents_ = 0; // 其余代码不能直接访问\n};\nstd::ostream& operator<<(std::ostream& os, const Money& m) { // 是非成员函数\n  return os << m.cents_; // 左侧流和右侧对象都可自然参与调用\n} // 只授权这个紧密协作接口；不要为方便广泛开放 private", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  C++ 中如何实现接口？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  C++ 没有 interface 关键字，通常用只定义公共操作的抽象基类表达运行时接口，纯虚函数声明可调用的行为，public 虚析构函数保证经基类指针删除派生对象时正确析构。实现类继承并用 override 实现接口。若只需编译期约束，也可用模板或 C++20 concept，不必引入虚调用。", size: 9.5pt)
  #raw("#include <memory>\nstruct Shape { virtual ~Shape() = default; // 经接口删除派生对象时正确析构\n  virtual double area() const = 0; // 接口规定行为，不能直接实例化\n};\nstruct Circle final : Shape { explicit Circle(double r) : r(r) {} double r;\n  double area() const override { return 3.14 * r * r; } };\nstd::unique_ptr<Shape> s = std::make_unique<Circle>(2.0);\nauto a = s->area(); // 若无需运行时异构分派，可用模板/concept 避免虚调用", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  C++ 中如何实现运算符重载？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  运算符重载本质上是定义 operator 符号对应的函数，可做成员函数或非成员函数。非成员形式常适合对称二元运算，也便于左操作数类型不属于本类；流插入通常写成返回流引用的非成员函数。重载应保持运算符原有直觉，不能新增符号、改变优先级或操作数个数，点号、作用域解析和条件运算符也不能重载。", size: 9.5pt)
  #raw("struct Vec2 { double x, y; Vec2& operator+=(Vec2 b) { x += b.x; y += b.y; return *this; } };\nVec2 operator+(Vec2 a, Vec2 b) { return a += b; } // 非成员使两个操作数对称\nVec2 p{1, 2}, q{3, 4};\nVec2 sum = p + q; // 保持“加法产生新值”的直觉\n// 不改变运算符优先级或操作数个数；不能重载 ., :: 或 ?:\n// 重载前先确认使用者会把它理解成普通向量加法", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  C++ 中的抽象类（Abstract Class）是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  只要类中仍有至少一个纯虚函数未实现，它就是抽象类，不能直接创建对象，通常用来规定派生类必须提供的接口。派生类只有实现所有继承来的纯虚函数后才可实例化；可以继续保持抽象。若通过基类指针管理派生对象，基类析构函数通常应为 virtual，避免销毁时只运行基类析构。", size: 9.5pt)
  #raw("struct Reader { virtual ~Reader() = default;\n  virtual int read() = 0; // 未实现的纯虚函数令 Reader 抽象\n};\nstruct FileReader : Reader { int read() override { return 1; } };\n// Reader r; // 错误：抽象类不能直接构造\nReader* r = new FileReader;\ndelete r; // 虚析构保证派生析构也执行；实际代码优先用智能指针", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  C++ 中的模板特化（Template Specialization）是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  全特化为模板参数给出一组完全确定的类型或值；类模板还可偏特化，以匹配例如指针类型或某类参数组合。函数模板没有偏特化规则，通常通过函数重载或约束表达类似选择。特化会改变某些类型的行为，优先考虑清晰的重载和 concept 约束，并检查特化声明可见性及重载歧义。", size: 9.5pt)
  #raw("template<class T> struct Kind { static constexpr int value = 0; };\ntemplate<class T> struct Kind<T*> { static constexpr int value = 1; }; // 类模板偏特化\nstatic_assert(Kind<int>::value == 0 && Kind<int*>::value == 1);\nint score(int x) { return x; }\ndouble score(double x) { return x; } // 函数模板“偏特化”用重载表达\n// 特化改变匹配类型的行为；优先用清晰重载/concept，避免歧义与声明不可见", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  C++ 中的类型擦除（Type Erasure）是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  类型擦除把具体类型隐藏在统一的运行时接口后面，使接口能接收多种类型，例如 std::function 保存不同可调用对象，std::any 保存满足要求的值。常见做法是用模板在编译期包装对象，再经虚函数或函数表间接调用。代价可能包括间接分派和动态分配；小对象优化是否触发由库实现决定。", size: 9.5pt)
  #raw("#include <functional>\nstd::function<int(int)> operation;\noperation = [](int x) { return x + 1; }; // 可替换为其他同签名闭包\noperation = [](int x) { return x * 2; };\nint answer = operation(3); // 统一运行时接口隐藏闭包具体类型\n// 类型擦除通常带间接调用；目标过大时可能分配，SBO 由库实现决定", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("007  C++ 中的纯虚函数（Pure Virtual Function）是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  纯虚函数在类内以 = 0 声明，表示基类不提供完整实现并使类成为抽象类。派生类需要覆盖所有未实现的纯虚函数才能成为具体类；即使提供纯虚函数的类外定义，它仍是纯虚函数，不能因此直接实例化。纯虚析构函数也必须提供定义，因为派生对象析构时仍会调用基类析构。", size: 9.5pt)
  #raw("struct Interface { virtual ~Interface() = 0; }; // 纯虚析构仍使类抽象\nInterface::~Interface() = default; // 仍必须给析构函数提供定义\nstruct Impl : Interface { /* 可继承析构 */ };\n// Interface x; // 错误：纯虚析构也算纯虚函数\nInterface* p = new Impl;\ndelete p; // 析构链会调用 Interface::~Interface()", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("008  C++ 中的继承有几种类型？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  按访问权限分，继承有 public、protected、private 三种；它们决定基类的 public/protected 成员在派生类中的可访问级别，不会让派生类直接访问基类 private 成员。public 继承表达可替代的子类型关系，通常用于多态接口；private 继承表达实现复用时应谨慎，也可考虑组合。", size: 9.5pt)
  #raw("struct Service { virtual void run() = 0; virtual ~Service() = default; };\nstruct Worker : public Service { void run() override {} }; // public 表示可替代\nstruct Detail {};\nclass Wrapper { Detail detail_; }; // 实现复用常可用组合，避免私有继承耦合\n// protected/private 继承会改变基类 public/protected 成员可见级别\n// 三种继承都不会让派生类直接访问基类 private 成员", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("009  C++ 中的虚函数是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  虚函数支持运行时多态：通过基类指针或引用调用时，执行对象动态类型中最终覆盖的函数；按值传递会发生对象切片，失去派生行为。派生声明用 override 可让编译器检查签名确实匹配。编译器常用虚表实现分派，但表结构和对象布局属于 ABI 约定，并非语言保证。", size: 9.5pt)
  #raw("struct Base { virtual int id() const { return 0; } virtual ~Base() = default; };\nstruct Child : Base { int id() const override { return 1; } };\nChild c; Base& ref = c;\nint dynamic_result = ref.id(); // 按动态类型分派到 Child\nBase sliced = c;\nint sliced_result = sliced.id(); // 按值复制发生切片，结果来自 Base\n// override 可检查签名；虚表是常见实现，不是标准规定的对象布局", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("010  C++ 中的虚拟继承是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  菱形结构中，两个中间派生类若普通继承同一个基类，最下层对象会含有两份基类子对象，访问成员可能歧义。把中间继承声明为 virtual 后，最派生对象只包含一份共享虚基类子对象。代价是布局和初始化规则更复杂，虚基类由最派生类负责初始化，具体偏移依 ABI。", size: 9.5pt)
  #raw("struct Root { explicit Root(int n) : n(n) {} int n; };\nstruct Left : virtual Root { Left() : Root(1) {} };\nstruct Right : virtual Root { Right() : Root(2) {} };\nstruct Join : Left, Right { Join() : Root(7), Left(), Right() {} };\nJoin j; // 只有一个共享 Root 子对象，值由最派生类 Join 初始化\n// 普通继承会有两份 Root，访问成员可能歧义\n// 虚基类布局/偏移依 ABI；虚继承也让构造顺序更复杂", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("011  C++ 中的赋值运算符重载如何实现？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  赋值运算符通常返回 *this 的 T&，这样 a = b = c 可以从右向左连续赋值。管理动态资源的类要正确处理自赋值和旧资源释放；copy-and-swap 可先构造副本，再无异常地交换状态，从而获得强异常保证。若支持移动赋值，应确保资源转移后源对象仍可安全析构，并按真实异常行为声明 noexcept。", size: 9.5pt)
  #raw("#include <utility>\nclass Buffer { public:\n  Buffer& operator=(const Buffer& other) {\n    Buffer temp(other); // 先完整构造副本；若分配失败原对象不变\n    swap(*this, temp); return *this; // 按引用返回支持 a = b = c\n  }\n  friend void swap(Buffer& a, Buffer& b) noexcept { a.swap_data(b); }\n  void swap_data(Buffer&) noexcept; // 示意：仅交换资源句柄/状态\n}; // 自赋值也安全；移动赋值另需让源对象可安全析构", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("012  C++ 和 C 有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  C++ 保留许多 C 的底层和过程式能力，同时增加类、模板、异常、命名空间、重载以及更丰富的标准库，可支持面向对象、泛型和函数式风格。它并非 C 的严格超集：部分同名语法或类型规则不同，C 代码也未必能直接作为 C++ 编译。跨语言接口通常用稳定的 C ABI 边界。", size: 9.5pt)
  #raw("// C ABI 常用于让 C 与 C++ 模块共享稳定边界\nextern \"C\" int add_numbers(int a, int b) { return a + b; }\n// C++ 调用方可使用类、模板和重载；C 调用方只见 C 风格函数签名\n// C++ 保留许多 C 能力，但不是严格超集，源代码规则并不完全相同\n// 跨语言边界避免直接暴露 std::string、模板类型或编译器特定类布局\n// 资源所有权和错误码也要约定，避免异常穿过 C ABI", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("013  C++ 多态如何分类与实现？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  编译期多态包括函数重载、模板和 concept 约束，调用目标在编译时按类型和约束选择；运行期多态主要由虚函数实现，经基类引用或指针依据动态类型分派。前者通常便于内联但可能增加实例代码，后者支持异构对象集合但有间接调用成本。多态基类通常要有虚析构函数。", size: 9.5pt)
  #raw("struct Base { virtual int value() const = 0; virtual ~Base() = default; };\nstruct One : Base { int value() const override { return 1; } };\ntemplate<class T> int static_call(const T& x) { return x.value(); } // 编译期绑定\nint dynamic_call(const Base& x) { return x.value(); } // 运行期按动态类型分派\nOne x; int a = static_call(x), b = dynamic_call(x);\n// 模板利于内联但增加实例代码；虚接口支持异构集合但有间接调用成本", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("1.2 对象模型、生命周期与类型", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("014  C++ 对象通常有哪些存储区？标准是否规定栈和堆？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  按标准语义，对象有自动、静态、线程和动态等存储期；常见操作系统还会把程序映像分成代码、全局数据、线程栈和动态分配区域。栈、堆是实现惯用称呼，标准不规定具体分区、方向或物理布局。判断对象何时销毁应看其存储期和所有权，而不是只看它位于哪个区域。", size: 9.5pt)
  #raw("#include <memory>\nint global = 0; // 静态存储期：整个程序期间存在\nthread_local int per_thread = 0; // 每个线程各有一份\nvoid f() { int local = 1; // 自动存储期，离开作用域销毁\n  auto dynamic = std::make_unique<int>(2); // 动态对象由所有者托管\n} // 判断生命周期看存储期/所有权；“栈、堆”只是常见实现布局说法\n// 标准不规定对象必须落在哪个物理分区或栈的增长方向", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("015  C++ 的默认特殊成员函数有哪些？Rule of Three/Five 是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  特殊成员函数包括默认构造、析构、拷贝构造/赋值和移动构造/赋值，编译器是否隐式声明或删除取决于类的成员及用户声明。Rule of Three/Five 提醒：手动管理资源时，析构、拷贝和移动语义要成套考虑。更好的常见做法是把资源交给容器和 RAII 成员，遵循 Rule of Zero。", size: 9.5pt)
  #raw("#include <string>\n#include <vector>\nstruct User { std::string name; std::vector<int> scores; }; // Rule of Zero\n// vector/string 自己处理资源；编译器生成的复制/移动通常就是正确语义\nstruct Raw { int* p; ~Raw() { delete p; } }; // 自管裸资源需审视拷贝和移动\n// Raw 若默认拷贝会双重释放；应禁拷贝并实现移动，或改用 RAII 成员\n// Rule of Three/Five 是检查清单，优先通过 Rule of Zero 避免手写", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("016  const 在变量、指针、引用和成员函数中分别有什么作用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  const 限制通过该表达式修改对象：const T* 表示不能经此指针改 T，T* const 表示指针本身不能改指向，const T& 提供只读访问。const 成员函数不能修改普通成员，但可修改声明为 mutable 的缓存等逻辑状态。const 对象不一定是编译期常量；需要常量表达式时使用 constexpr 并满足其求值条件。", size: 9.5pt)
  #raw("int x = 1;\nconst int* pointee_readonly = &x; // 不能经此指针修改 x\nint* const fixed_pointer = &x; // 指针不能改指向\nconst int& read_only_ref = x; // 只读别名\nstruct Cache { mutable int hits = 0; int get() const { ++hits; return 1; } };\n// const 不等于编译期常量；constexpr 还要求表达式满足常量求值规则", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("017  explicit 关键字有何作用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  explicit 用来阻止构造函数或转换函数被隐式转换链使用，尤其适合单参数构造，避免把一个普通值意外转成类对象；显式直接构造仍可调用它。C++11 起转换运算符也能声明 explicit，C++20 可用条件 explicit 按模板参数决定。引入它时要检查现有初始化和函数参数调用是否依赖隐式转换。", size: 9.5pt)
  #raw("struct Port { explicit Port(int n) : value(n) {} int value; };\nPort a{8080}; // 直接初始化可调用 explicit 构造\n// Port b = 8080; // 错误：阻止意外的隐式转换\nvoid connect(Port);\n// connect(8080); // 错误；connect(Port{8080}) 意图清晰\n// C++20 还可写 explicit(condition)；添加 explicit 时检查旧调用点", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("018  mutable 关键字是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  mutable 允许 const 成员函数修改被它修饰的非静态成员，不改变对象对外可观察的逻辑值时很有用。例如延迟计算缓存、统计计数或互斥锁可以声明为 mutable。它不是线程安全工具：多个线程并发访问该成员仍须加锁或使用原子类型，也不能借它绕过对象本身的生命周期规则。", size: 9.5pt)
  #raw("#include <mutex>\nclass Memo {\n  mutable std::mutex m_; // const 查询仍可同步缓存\n  mutable bool ready_ = false; mutable int cached_ = 0;\npublic: int value() const { std::lock_guard<std::mutex> lock(m_);\n    if (!ready_) { cached_ = 42; ready_ = true; } return cached_; }\n}; // mutable 适合逻辑上不改变结果的缓存/锁\n// mutable 本身不提供同步；并发访问必须加锁或使用原子类型", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("019  sizeof 和 alignof 的作用是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  sizeof(T) 给出 T 对象表示的字节数，数组结果包含所有元素而指针结果只包含指针本身；alignof(T) 给出类型所需的对齐。结构体成员之间和末尾可能有填充，因此成员顺序会影响大小。具体数值由实现和 ABI 决定，不能把本机 sizeof 当成跨平台序列化格式。", size: 9.5pt)
  #raw("#include <iostream>\nstruct Record { char tag; double value; };\nstd::cout << sizeof(Record) << ' ' << alignof(Record); // 实际数值依 ABI\nstd::cout << ' ' << sizeof(char); // 单个成员类型大小\n// 成员间/末尾可能填充以满足对齐；数组大小含所有元素\n// 不要把本机 sizeof/布局直接当网络协议或跨平台文件格式", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("020  static 在 C++ 中有哪些常见用法？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  局部 static 对象具有静态存储期，在控制流首次经过定义时初始化；C++11 起此初始化由语言保证线程安全。命名空间作用域 static 通常赋予名字内部链接，类 static 数据成员则属于类而非某个实例。初始化完成后对共享状态的读写仍可能有数据竞争，需单独设计同步。", size: 9.5pt)
  #raw("struct Registry { static int count; }; // 类级数据，不属于某个实例\nint Registry::count = 0; // 非 inline 成员在一个源文件定义一次\nint& shared_state() { static int state = 0; return state; }\n// 首次经过时初始化由 C++11 保证线程安全\n++shared_state(); // 初始化安全不代表之后的并发写安全\n// 命名空间 static 通常内部链接；局部 static 生命周期贯穿程序", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("021  typedef 和 using 有何区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  typedef 与 using 都创建类型别名，不会产生新的类型。using Alias = Existing; 对复杂函数指针更清晰，也支持 template<class T> using Vec = std::vector<T> 这样的别名模板；typedef 不能直接定义别名模板。二者都只是命名类型，无法解决原类型本身的隐式转换或封装问题。", size: 9.5pt)
  #raw("#include <vector>\ntypedef unsigned long LegacyId;\nusing Id = unsigned long; // 现代别名写法更易读\ntemplate<class T> using Vec = std::vector<T>; // 别名模板\nVec<int> values{1, 2};\n// typedef 也能命名普通类型，但不能直接声明 template alias\n// 两者都只是别名，不会创建新类型或阻止隐式转换", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("022  什么是C++中的多重继承，如何避免菱形继承？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  多重继承让一个类同时获得多个基类接口或实现。若两个路径都普通继承同一祖先，最下层对象会保存两份祖先状态，访问需指明路径；对共享的共同基类采用虚继承可只保留一个子对象。虚继承会改变对象布局和构造责任，接口设计中应优先避免不必要的复杂菱形结构。", size: 9.5pt)
  #raw("struct A { int id = 0; };\nstruct B : virtual A {};\nstruct C : virtual A {};\nstruct D : B, C {}; // 虚继承使最底层 D 共享一个 A\nD d; d.id = 1;\n// 普通继承会有 B::A 和 C::A 两个子对象，d.id 有歧义\n// 若只为复用实现，组合通常比多重/虚继承更易维护", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("023  什么是内联函数（inline）？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  inline 不命令编译器一定展开调用；是否展开由优化器根据函数大小、调用上下文等决定。它的重要语言作用是允许满足 ODR 条件的定义出现在多个翻译单元，类内定义的成员函数通常隐式 inline。过度内联会扩大代码体积、损害指令缓存，因此性能判断应看基准和生成代码。", size: 9.5pt)
  #raw("// 适合放在头文件供多个翻译单元包含\ninline int clamp_low(int value) { return value < 0 ? 0 : value; }\nint result = clamp_low(-1); // inline 不保证机器码展开\n// inline 的语言作用包括允许符合 ODR 的相同定义跨翻译单元出现\n// 编译器仍会根据优化和调用上下文决定是否内联；过度展开增大代码\n// 大函数放头文件也会扩大每个包含者的编译工作", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("024  什么是对象切片？如何避免？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  把派生对象按值复制到基类对象时，只保留基类子对象，派生字段和动态行为信息被切掉，这叫对象切片。多态接口应接收基类引用或指针；异构对象容器可使用智能指针保存派生对象。若需要值语义，可用显式 clone 等机制定义多态复制，而非直接按基类值复制。", size: 9.5pt)
  #raw("struct Shape { virtual double area() const { return 0; } virtual ~Shape() = default; };\nstruct Circle : Shape { double area() const override { return 12; } };\nCircle c;\nShape copy = c; // 按值复制切掉 Circle 部分\nShape& view = c; // 引用保留动态对象\n// API 用引用/指针传多态对象；需要多态复制时定义 clone() 明确语义\n// 异构容器可保存 std::unique_ptr<Shape>", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("025  什么是构造函数和析构函数的顺序？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  构造时先构造虚基类，再按基类声明顺序构造直接基类，最后按成员声明顺序构造成员；析构顺序完全反向，而不是按初始化列表书写顺序。局部对象在作用域退出时析构，动态对象在 delete 时析构。经基类指针删除派生对象时，基类析构需为 virtual。", size: 9.5pt)
  #raw("#include <string>\nstruct Part { Part(const char* n) : name(n) { log(name); } ~Part() { log(\"~\" + name); } std::string name; };\nstruct Base { Base() { log(\"Base\"); } virtual ~Base() { log(\"~Base\"); } };\nstruct Child : Base { Part first{\"first\"}, second{\"second\"};\n  Child() : second(\"second\"), first(\"first\") {} // 实际仍按声明顺序\n  ~Child() { log(\"~Child\"); }\n}; // 构造基类→成员声明序；析构反向；虚基类先于直接基类构造", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("026  命名空间有什么作用？头文件中如何避免污染全局命名空间？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  命名空间把名字分组，降低不同库间的冲突；使用限定名如 lib::Type 或局部 using 声明可控制引入范围。头文件中的 using namespace 会把大量名字带入所有包含者的作用域，容易造成歧义，因此应避免。匿名命名空间适合在实现文件中隐藏仅本文件使用的名字。", size: 9.5pt)
  #raw("namespace graphics { struct Color {}; }\nvoid draw() {\n  using graphics::Color; // 仅在本函数引入这个名字\n  Color c;\n}\n// 头文件里不要写 using namespace graphics; 会污染所有包含者\n// 直接使用 graphics::Color 最明确；匿名 namespace 可隐藏 .cpp 私有名字", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("027  如何实现 C++ 中的单例模式（Singleton）？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  常见单例把构造函数设为 private，删除拷贝和移动操作，并通过静态函数提供访问点。函数内局部 static 实现简单，C++11 起首次初始化线程安全；但之后共享状态的并发访问仍要同步。还应评估全局生命周期和退出析构顺序，测试中可注入接口替代单例依赖。", size: 9.5pt)
  #raw("class Config { Config() = default; public:\n  Config(const Config&) = delete; Config& operator=(const Config&) = delete;\n  static Config& instance() { static Config one; return one; }\n  int read() const { return 1; }\n};\nauto value = Config::instance().read();\n// 局部 static 首次初始化线程安全；后续可变状态仍需同步\n// 测试和析构顺序复杂时，优先依赖注入而非全局单例", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("028  引用（Reference）与指针（Pointer）有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  引用声明时必须绑定对象，之后通常不能改绑，也没有空引用这一正常语义；指针可以为空或改指向，需要用 * 或 -> 间接访问。引用在实现中也可能占空间，不能依赖它一定是别名且零成本。API 中用引用表达必需对象，用指针表达可选对象，并另行明确所有权。", size: 9.5pt)
  #raw("void use_required(int& x) { ++x; } // 引用表达必须存在的对象\nvoid use_optional(int* x) { if (x) ++*x; } // 指针可为空且可改指向\nint value = 0; int& alias = value; int* ptr = &value;\nint other = 1; ptr = &other; // 可重新指向；alias = other 是赋值 value\n// 引用声明时须绑定，通常不能重新绑定；两者都不自动表达所有权\n// 返回借用引用/指针时，调用方必须确保目标仍存活", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("029  构造函数和析构函数分别负责什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  构造函数负责建立对象不变量并获取或初始化成员资源，析构函数负责释放对象拥有的资源；成员对象会自动按逆序析构。局部对象离开作用域时自动清理，动态对象由 delete 触发析构。若通过基类指针销毁派生对象，基类析构必须为 virtual，否则行为未定义。", size: 9.5pt)
  #raw("#include <memory>\n#include <string>\nstruct FileHandle { explicit FileHandle(int fd) : fd(fd) {} ~FileHandle() { close_fd(fd); }\n  int fd; void close_fd(int); };\nvoid process() { auto file = std::make_unique<FileHandle>(open_file());\n  read_data(file->fd); // 正常返回或异常离开时都由析构清理\n}\n// 构造建立对象不变量/取得资源；析构释放自己拥有的资源\n// 经基类指针删除派生对象时基类析构需 virtual", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("1.3 模板与初始化", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("030  模板（Template）是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  模板以类型、值或模板参数描述一族函数或类，编译器在具体参数出现时实例化对应代码，因此可实现静态多态和通用容器。模板还支持编译期计算与类型选择。代价是诊断和构建可能更复杂，实例过多会增加目标文件体积；用 concept 或类型约束可让接口意图更清楚。", size: 9.5pt)
  #raw("template<class T> T larger(T a, T b) { return a < b ? b : a; }\nint i = larger(3, 5); double d = larger(1.0, 2.0);\n// 调用时编译器实例化适合 T 的实现，形成静态多态\n// 可用模板复用算法而不用运行期虚调用\n// 用 concept/约束表达所需操作，减少不清楚的模板报错和过度实例化\n// 同一模板参数会生成相应实例，构建体积也要留意", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("031  深拷贝与浅拷贝有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  浅拷贝逐成员复制，若成员只是裸指针，两个对象会指向同一资源，可能互相修改、悬空或重复释放；深拷贝则为副本独立创建资源。若共享本来就是语义，应明确采用 shared_ptr 等共享所有权。自管资源的类要定义完整拷贝/移动策略，优先用 RAII 成员和 Rule of Zero。", size: 9.5pt)
  #raw("#include <vector>\nstruct Shallow { int* p; }; // 默认拷贝只复制地址，两对象会别名\nstruct Deep { std::vector<int> values; }; // 容器复制时复制元素\nint external = 1; Shallow a{&external}; Shallow b = a; // 两者指向同一 int\n*b.p = 9; // 通过 b 修改会影响 a 所指的值\n// 裸指针不说明是否拥有资源；不要让两个对象都负责 delete\nDeep x{{1, 2}}, y = x; y.values[0] = 9; // x 不受影响\n// 若资源应共享，明确用 std::shared_ptr；通常优先 Rule of Zero", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("032  类型转换（static_cast、dynamic_cast、const_cast、reinterpret_cast）有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  static_cast 用于有明确语言语义的转换，如数值转换或已知层次中的上转型；dynamic_cast 对多态类型做运行时检查，下转失败时指针得 nullptr、引用抛 bad_cast。const_cast 只增删 cv 限定，修改原本 const 对象会触发未定义行为。reinterpret_cast 只适用于低层表示转换，不能保证跨平台含义。", size: 9.5pt)
  #raw("#include <typeinfo>\nstruct Base { virtual ~Base() = default; }; struct Child : Base {};\nBase* b = new Child;\nChild* checked = dynamic_cast<Child*>(b); // 运行时检查；失败得 nullptr\nint n = static_cast<int>(3.8); // 明确数值转换，可能丢信息\nconst Base* cb = b;\nBase* writable = const_cast<Base*>(cb); // 原对象非 const，去限定后可写\n// 若最初对象本来就是 const，经转换修改会是未定义行为\n// reinterpret_cast 只用于受控低层表示；不保证跨平台意义\n// dynamic_cast 引用下转失败会抛 std::bad_cast；用完释放 b", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("033  默认构造函数和拷贝构造函数分别是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  默认构造函数是不提供必需实参即可构造对象的构造函数，可能由编译器隐式生成，也可显式声明为 default。拷贝构造函数以同类型对象初始化新对象，典型形式是 T(const T&)；它不同于对已存在对象执行的拷贝赋值。用户声明某些构造或移动操作会改变隐式生成规则，应检查是否被删除。", size: 9.5pt)
  #raw("struct Item { Item() = default; Item(const Item&) = default; int value = 0; };\nItem first; Item second(first); // 默认构造 vs 新对象拷贝构造\nItem third = first; // 这里仍是拷贝构造，不是赋值\nthird = second; // 这是拷贝赋值，对象已存在\nstruct NeedsArg { explicit NeedsArg(int) {} };\n// 编译器不一定生成默认构造；用户声明构造后通常需显式 default", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("034  C++ 中列表初始化和圆括号初始化有哪些区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  花括号列表初始化能拒绝窄化转换，例如把小数放进 int 会编译失败；对类类型，它会先尝试 initializer_list 构造函数，因此有时与圆括号选中不同的重载。圆括号是直接初始化，通常不做窄化检查。简单聚合类型还可按成员顺序用花括号初始化，适合显式表达字段值。〔S2〕", size: 9.5pt)
  #raw("#include <vector>\nstd::vector<int> items{3, 4}; // initializer_list 构造：两个元素\nstd::vector<int> fill(3, 4); // 圆括号：三个值为 4 的元素\n// 花括号还检查窄化，int x{3.5}; 会编译失败\nstruct Pair { int left; int right; };\nPair p{1, 2}; // 聚合按成员顺序初始化\n// 类有 initializer_list 重载时，花括号会优先匹配它，可能改变重载选择", lang: "cpp", block: true)
]

#heading(level: 1, outlined: true)[#text("第2章 内存与资源管理", size: 15pt, weight: "bold", fill: rgb("#000000"))]
#heading(level: 2, outlined: true)[#text("2.1 所有权与 RAII", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  C++ 中如何使用智能指针？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  unique_ptr 表示单一所有者，移动可转移所有权且不允许默认拷贝；shared_ptr 在确需共同生命周期时共享控制块；weak_ptr 观察 shared_ptr 管理对象但不增加强引用。优先用 make_unique/make_shared 建立对象，把所有权写进类型。互相持有 shared_ptr 会形成环，应把非拥有方向改成 weak_ptr。", size: 9.5pt)
  #raw("#include <memory>\nstruct Node { std::weak_ptr<Node> parent; std::shared_ptr<Node> child; };\nauto root = std::make_shared<Node>(); // 多方确实共享生命周期才用 shared_ptr\nauto child = std::make_shared<Node>(); root->child = child;\nchild->parent = root; // 反向观察用 weak_ptr，避免引用环导致永不释放\nauto sole = std::make_unique<Node>(); // 单一所有者优先用 unique_ptr\n// weak_ptr::lock() 成功时才临时取得共享所有权", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  C++ 中如何管理内存？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先明确资源何时开始和结束，再让所有权由局部对象、标准容器或智能指针表达。自动存储期对象通常随作用域结束销毁，静态对象贯穿程序生命周期，动态存储应由 RAII 对象托管。标准规定的是存储期和分配语义，不要求实际一定有物理意义上的栈区或堆区。", size: 9.5pt)
  #raw("#include <memory>\n#include <vector>\nint global = 0; // 静态存储期\nthread_local int scratch = 0; // 每个线程一份\nvoid work() { std::vector<int> local{1, 2}; // 自动对象，离开作用域析构\n  auto heap = std::make_unique<int>(3); // 动态对象由局部所有者托管\n} // 不直接依赖“栈/堆”说法；标准关心存储期与对象生命周期\n// 分配细节由实现决定，确定所有权比猜物理区域更重要", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  C++ 中的内存对齐（Memory Alignment）是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  对齐要求表示对象地址必须满足某个边界，alignof 可查询类型要求，alignas 可请求更严格的对齐。结构体成员间和末尾填充用于确保每个成员地址合规；过度对齐分配也需匹配分配接口。网络或文件格式应逐字段编码，不要直接写入本机结构体字节并假设布局一致。", size: 9.5pt)
  #raw("#include <cstddef>\nstruct Plain { char c; double value; }; // 成员间可能出现填充\nstruct PackedOrder { double value; char c; }; // 顺序可能减少填充\nstruct alignas(64) Slot { int value; }; // 请求更严格对齐\nstatic_assert(alignof(Slot) >= 64);\n// 数值/布局仍依实现；过度对齐动态分配需配套正确分配接口\n// 文件和网络协议逐字段编码，不直接写入结构体原始字节", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  C++ 中的垃圾回收与手动内存管理有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  传统 C++ 常通过 RAII 和确定性析构及时释放对象资源，也可接入追踪式垃圾回收或用引用计数管理对象图。GC 依赖可达性回收内存，但文件、锁、事务等外部资源仍需显式控制释放时机；追踪 GC 还可能引入暂停。选择方案应看延迟、吞吐和资源种类，而非只比较是否手动 free。", size: 9.5pt)
  #raw("#include <fstream>\n#include <fstream>\nvoid process() {\n  std::ifstream file(\"input.txt\"); // RAII 在作用域退出时关闭资源\n  if (!file) return;\n  use_file(file);\n} // 即使异常栈展开，文件仍确定关闭\n// 垃圾回收器管理可达内存不等于及时释放文件、锁或事务\n// 追踪 GC 可能有暂停；资源释放时机应按延迟和资源类型设计", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  new/delete 与 malloc/free 有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  new 表达式先取得合适存储，再调用构造函数；delete 表达式先析构对象再释放存储。malloc/free 只处理字节，不调用 C++ 构造和析构，不能与 new/delete 混搭；数组 new[] 要配对 delete[]。业务代码优先用容器和 make_unique，只有实现分配器时才直接管理原始存储。", size: 9.5pt)
  #raw("#include <cstdlib>\nWidget* p = new Widget(args...); // 分配存储并调用构造函数\ndelete p; // 调用析构后释放；必须成对使用 new/delete\nvoid* raw = std::malloc(sizeof(Widget)); // 只取得字节，不构造 Widget\nstd::free(raw); // malloc/free 配对；不能 delete raw\n// 数组 new[] 配 delete[]；业务代码优先容器/智能指针而非原始分配", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  什么是 RAII（资源获取即初始化）？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  RAII 把资源所有权绑定到对象：构造成功后对象持有资源，析构时释放。作用域正常退出和异常栈展开都会调用析构，因此可用 unique_ptr、lock_guard、文件流和容器避免手工遗漏清理。资源获取若可能失败，构造应保持异常安全，不要把未完整初始化的所有权暴露出去。", size: 9.5pt)
  #raw("#include <fstream>\n#include <mutex>\nvoid write_log(std::mutex& m) {\n  std::lock_guard<std::mutex> lock(m); // 获锁即建立资源所有权\n  std::ofstream file(\"log.txt\");\n  file << \"entry\\n\";\n} // 异常或提前返回也会逆序析构：先关文件，再解锁\n// 这种 RAII 清理比每条路径手写 unlock/close 更可靠", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("2.2 分配策略与内存优化", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("007  什么是内存池（Memory Pool）？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  内存池预留一批存储并按固定尺寸或大小类重复分配，减少通用分配器开销和外部碎片，适合高频、尺寸相近或生命周期集中对象。实现时必须分别处理存储分配与对象构造析构，还要考虑对齐、池耗尽、线程安全和释放策略。池不一定更快，需用真实分配分布做基准。", size: 9.5pt)
  #raw("#include <vector>\n#include <memory_resource>\nstd::pmr::unsynchronized_pool_resource pool; // 复用大小相近的分配块\n{\n  std::pmr::vector<Node> nodes{&pool}; // 元素仍需正常构造/析构\n  nodes.emplace_back(); nodes.emplace_back();\n} // 容器先销毁元素，再由 pool 回收存储\n// pool 耗尽、对齐与线程安全策略都要定义；并先用真实负载测速度", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("008  如何减少 C++ 程序中的内存碎片？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先用分配器统计或 profiler 判断是外部碎片、内部碎片还是峰值占用问题。尺寸稳定的对象可用大小类、对象池；生命周期相近的临时对象可用 arena/单调资源，整批释放。池化会增加保留内存，且需考虑对齐、线程竞争和池耗尽，不能只看分配速度就判定优化成功。", size: 9.5pt)
  #raw("#include <vector>\n#include <memory_resource>\nstd::pmr::monotonic_buffer_resource arena; // 一批临时对象统一分配\n{\n  std::pmr::vector<Node> frame{&arena};\n  build_frame(frame); render(frame);\n} // 容器先结束元素生命周期；arena 再一次性回收区块\n// 同生命周期对象适合 arena；池化会多保留内存，不一定减少总占用\n// 用 profiler 区分碎片、峰值占用和分配开销后再选大小类/池", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("009  如何通过 std::move 实现高效的内存管理？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  std::move 本质是把表达式转换成可绑定右值引用的值类别，不会复制或搬运任何字节。随后是否调用移动构造取决于目标类型是否提供可用移动操作；资源类可在移动时转交指针、文件句柄等。移动后的对象仍须有效且可析构，但其值通常未指定，应只做类型保证的操作或重新赋值。", size: 9.5pt)
  #raw("#include <memory>\n#include <utility>\nauto source = std::make_unique<Buffer>(size);\nauto destination = std::move(source); // 这里只转换值类别，不搬运字节\n// unique_ptr 的移动构造接手句柄；source 现在为空\nif (!source) source = std::make_unique<Buffer>(new_size); // 可重新赋值\n// 普通移动后对象通常只保证有效可析构，具体值未指定", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("010  如何避免 C++ 中的内存泄漏？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  优先用自动对象、标准容器和 RAII 管理文件句柄、锁及动态资源，避免裸 new 后在多个返回路径手动 delete。unique_ptr 表达独占所有权，shared_ptr 只用于真正共享生命周期，weak_ptr 可打破引用环。AddressSanitizer/LeakSanitizer 等工具可检查泄漏和越界，但仍需覆盖异常及提前返回路径。", size: 9.5pt)
  #raw("#include <memory>\nstd::unique_ptr<Widget> make_widget() { return std::make_unique<Widget>(); }\nvoid run() {\n  auto object = make_widget();\n  if (condition()) return; // 提前返回也自动释放\n  process(*object);\n} // 异常展开也清理；共享所有权仅在确需时用 shared_ptr\n// weak_ptr 可打破所有权环；测试构建可启用 Address/LeakSanitizer", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("011  什么是 placement new？它和普通 new 有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  placement new 在调用方给定的地址上开始对象生命周期并执行构造，不负责申请那块存储，因此不能对它直接 delete。调用方必须确保缓冲区足够大、满足对齐且生命周期覆盖对象；对象结束后显式调用析构，再按原来取得存储的方式释放。常用于对象池和底层容器实现。〔S2〕", size: 9.5pt)
  #raw("#include <cstddef>\n#include <new>\n#include <memory>\nalignas(T) std::byte storage[sizeof(T)]; // 足够大且满足 T 对齐\nT* object = ::new (static_cast<void*>(storage)) T(args...); // 只开始生命周期\nuse(*object);\nstd::destroy_at(object); // 显式析构；placement new 不负责释放存储\n// 仅在原始缓冲区生命周期结束/释放策略执行后回收 storage", lang: "cpp", block: true)
]

#heading(level: 1, outlined: true)[#text("第3章 现代 C++ 与模板", size: 15pt, weight: "bold", fill: rgb("#000000"))]
#heading(level: 2, outlined: true)[#text("3.1 语言特性与类型系统", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  C++ 中如何实现自定义的内存管理器？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  自定义分配器要把存储分配与对象构造分开设计：allocator 只提供满足大小和对齐的原始存储，容器再在其中构造元素。固定尺寸、高频对象可用预分配池和空闲链表；通用 allocator 还要满足标准库的传播、相等性和重绑定等要求。全局重载 new/delete 影响面很大，应先证明默认分配器是瓶颈。", size: 9.5pt)
  #raw("#include <vector>\n#include <memory_resource>\nstd::pmr::unsynchronized_pool_resource pool; // 面向相近尺寸的复用池\n{\n  std::pmr::vector<Node> nodes{&pool}; // 容器在原始存储中构造元素\n  for (int i = 0; i < 100; ++i) nodes.emplace_back();\n} // 先析构元素，再让资源池回收存储\n// 通用 allocator 还需满足传播/相等性等要求；unsynchronized_pool_resource 不可并发共享\n// 自定义全局 new 影响全程序；先证明分配器是瓶颈", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  C++ 中的 auto 关键字是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  auto 根据初始化表达式推导类型，使用值形式时通常像模板按值推导一样去除顶层 const 和引用；auto& 会保留引用，const auto 增加只读限定，auto&& 在适用场景下是转发引用。decltype(auto) 按 decltype 规则保留精确类型和值类别。遍历容器时用 auto& 可避免复制元素，需留意代理引用类型。", size: 9.5pt)
  #raw("#include <string>\n#include <vector>\nstd::vector<std::string> names{\"Ada\", \"Lin\"};\nauto copy = names[0]; // 值推导去掉引用，复制字符串\nconst auto& view = names[1]; // 保留只读引用，不复制元素\nauto&& forwarding = names[0]; // 在适当模板/推导语境中是转发引用\n// decltype(auto) 按 decltype 规则保留精确引用和值类别\n// vector<bool> 的元素访问可能是代理对象，auto& 不一定适用", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  C++ 中的 noexcept 关键字如何使用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  noexcept 声明函数不向外传播异常；若异常逃出 noexcept 函数，运行时会调用 std::terminate。noexcept(expr) 可在编译期查询表达式是否不抛，条件异常规范常用于模板转发。移动操作只有确实不会抛时才标 noexcept，因为 vector 等容器在扩容时可能据此选择移动而非为异常安全回退到拷贝。", size: 9.5pt)
  #raw("#include <type_traits>\nstruct MoveOnly { MoveOnly(MoveOnly&&) noexcept = default; };\nstatic_assert(std::is_nothrow_move_constructible_v<MoveOnly>);\nvoid never_fails() noexcept { /* 异常若逃逸会调用 std::terminate */ }\n// vector 扩容时可能为强异常保证回退到拷贝\n// 移动操作只有确实不抛才标 noexcept，不能作为优化装饰\n// noexcept(expr) 还可在模板中查询表达式的异常属性", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  C++ 中的 typeid 是如何工作的？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  typeid 返回 std::type_info，可比较类型信息或用 name 查看实现相关名称。对普通表达式通常检查静态类型；对多态类的 glvalue 会求值并报告动态类型，因此相关表达式可能有副作用。它依赖 RTTI；对空指针解引用后应用 typeid 检查多态对象会抛 std::bad_typeid，不能把 name 当作跨平台稳定标识。", size: 9.5pt)
  #raw("#include <typeinfo>\nstruct Base { virtual ~Base() = default; }; struct Derived : Base {};\nBase* p = new Derived;\nbool same = (typeid(*p) == typeid(Derived)); // 多态 glvalue 得到动态类型\nconst char* name = typeid(*p).name(); // 名称格式由实现决定\n// 非多态表达式通常只报告静态类型；RTTI 需启用\n// 不要解引用空多态指针再 typeid；那会抛 std::bad_typeid\ndelete p;", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  C++ 中的模板元编程（Template Metaprogramming）是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  模板元编程借助模板实例化、constexpr 和类型特征在编译期计算值或选择实现，例如按类型能力启用某个算法。它能把检查和分派前移到编译期，但复杂递归模板会让诊断和编译变慢。现代代码可用 constexpr 函数直接计算、用 concepts 表达约束，通常比深层模板技巧更易读。", size: 9.5pt)
  #raw("#include <cstddef>\ntemplate<std::size_t N> struct Factorial {\n  static constexpr std::size_t value = N * Factorial<N - 1>::value;\n};\ntemplate<> struct Factorial<0> { static constexpr std::size_t value = 1; };\nstatic_assert(Factorial<5>::value == 120); // 编译期实例化递归模板\nconstexpr std::size_t fact(std::size_t n) { return n < 2 ? 1 : n * fact(n - 1); }\n// 常量表达式通常更清楚；深层 TMP 会增加编译时间和诊断难度", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  C++ 中的类型推导（Type Deduction）是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  推导规则取决于上下文。auto 按近似模板按值规则推导，auto& 保留左值引用和 const；函数模板的 T、T&、T&& 参数也分别按值、左值引用和转发引用规则推导，转发引用会根据实参值类别折叠。decltype(auto) 使用 decltype 规则，可能得到引用，因此从局部变量返回时需检查是否悬空。", size: 9.5pt)
  #raw("#include <utility>\nint x = 1; const int cx = 2;\nauto a = cx; // 按值推导为 int，顶层 const 被去掉\nconst auto& b = cx; // 保留 const 引用\ntemplate<class T> decltype(auto) identity(T&& value) { return std::forward<T>(value); }\n// 模板 T&& 对左值折叠为左值引用，对右值保持右值引用\n// 返回引用时要确认对象活得足够久，避免悬空", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("007  C++11 中的 Lambda 表达式是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Lambda 会生成一个匿名闭包类型，其 operator() 保存函数体和捕获状态；按值捕获保存副本，按引用捕获仍依赖原变量生命周期。C++14 支持初始化捕获，可移动捕获独占资源；C++20 可写模板形参列表。若闭包被异步保存或返回，不要引用捕获短生命周期局部变量。", size: 9.5pt)
  #raw("#include <memory>\n#include <utility>\n#include <memory>\n#include <utility>\nauto make_task(std::unique_ptr<Job> job) {\n  return [owned = std::move(job)] { owned->run(); }; // 初始化捕获转移所有权\n}\nint total = 0; auto add = [&total](int n) { total += n; }; // 依赖 total 生命周期\nadd(3);\n// 闭包保存捕获状态；异步保存时避免引用短生命周期局部变量\n// 按值捕获可保存副本，必要时用 mutable 改闭包自己的副本", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("008  C++11 引入的 nullptr 有什么用法？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  nullptr 是类型为 std::nullptr_t 的空指针字面量，可转换为任意对象指针或函数指针，但不会像整数 0 一样匹配普通整数重载。使用它能避免 NULL 在不同平台可能是整数宏而产生的重载歧义，例如 f(int) 与 f(char*) 并存时 f(nullptr) 明确选择指针语义。", size: 9.5pt)
  #raw("#include <cstddef>\nvoid open(int); void open(const char*);\nopen(nullptr); // 空指针语义，选择指针重载\nopen(0); // 整数 0 匹配 int，历史 NULL 宏也可能是整数\nstd::nullptr_t empty = nullptr;\n// nullptr 可转换为对象/函数指针，不会误选整数重载\n// 需要头文件 <cstddef> 才直接命名 std::nullptr_t", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("009  inline 函数与宏有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  宏在预处理阶段做无类型文本替换，缺少作用域和类型检查，带副作用的参数还可能重复求值；inline 函数保留正常参数求值和类型检查，可调试也受作用域控制。inline 允许符合 ODR 的定义出现在多个翻译单元，但不保证机器码内联。宏仍可用于条件编译等预处理需求。", size: 9.5pt)
  #raw("inline int square(int x) { return x * x; } // 类型检查，参数只求值一次\nint i = 3; int value = square(i++); // i 只递增一次\n#define SQUARE_BAD(x) ((x) * (x))\nint j = 3;\n// int wrong = SQUARE_BAD(j++); // 会重复递增且产生未定义行为\n// inline 不保证生成机器码内联，但可满足多翻译单元 ODR 例外\n// 宏仍适合条件编译；函数更安全、可调试、受作用域控制", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("3.2 值类别、移动与泛型", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("010  右值引用、移动语义、std::move 与 std::forward 的关系是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  右值引用让类型可实现资源转移的移动构造和移动赋值；std::move 只是把表达式转换为右值类别，真正是否移动由重载决议决定。std::forward<T> 仅用于转发引用模板，按推导出的 T 保留实参原本是左值还是右值。移动后对象仍可析构和重新赋值，其他值通常未指定。", size: 9.5pt)
  #raw("#include <string>\n#include <utility>\nvoid consume(std::string&& text) { store(std::move(text)); }\ntemplate<class F, class... Args>\ndecltype(auto) forward_call(F&& f, Args&&... args) {\n  return std::forward<F>(f)(std::forward<Args>(args)...);\n}\n// std::move 只转换值类别，移动由目标类型的重载实现\n// std::forward<T> 仅在转发引用模板里按 T 保留实参原值类别", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("011  如何使用 C++ 实现延迟计算（Lazy Evaluation）？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  延迟计算可把工作包装成 lambda 或函数对象，等调用方真正需要结果时再执行；对于可能重复读取的结果，可保存计算状态并缓存一次结果。std::optional 能区分尚无结果与已有结果，std::call_once 可协调单次初始化。要考虑线程安全、异常后是否重试，以及闭包引用的对象是否仍存活。", size: 9.5pt)
  #raw("#include <mutex>\n#include <mutex>\n#include <optional>\nclass LazyValue { mutable std::optional<int> cache_; mutable std::once_flag once_;\npublic: int get() const { std::call_once(once_, [&] { cache_ = expensive_compute(); }); return *cache_; }\n};\n// 闭包/函数对象可推迟计算；optional 区分未计算和结果为 0\n// call_once 成功初始化后只执行一次；异常时后续调用可重试\n// 引用捕获对象仍须活得比延迟任务久", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("012  如何实现 C++ 中的类型萃取（Type Traits）？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  类型特征在编译期回答类型属性问题，标准库已有 is_integral、is_pointer、remove_reference 等，通常应优先复用。自定义特征可用主模板定义默认结果，再为特殊类型偏特化，并继承 true_type/false_type 提供编译期布尔值。C++17 的 void_t 可检测某个类型表达式是否有效；C++20 concept 更适合公开约束接口。", size: 9.5pt)
  #raw("#include <type_traits>\n#include <utility>\n#include <vector>\ntemplate<class T> struct is_pointer_like : std::false_type {};\ntemplate<class T> struct is_pointer_like<T*> : std::true_type {}; // 偏特化\nstatic_assert(is_pointer_like<int*>::value);\nusing ValueType = std::remove_cvref_t<const int&>; // 先复用标准特征\nstatic_assert(std::is_same_v<ValueType, int>); // C++20 concept 可直接写约束", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("013  C++20 Concepts 与 SFINAE 有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Concepts 用 requires 直接写出类型必须满足的表达式或性质，并参与约束排序，错误信息通常更贴近调用点。SFINAE 是模板替换失败时把候选从重载集中移除，常通过 enable_if、检测惯用法实现，兼容旧标准且仍适合一些细粒度选择。两者规则不完全等价，迁移时要检查重载集合是否改变。〔S1，S2〕", size: 9.5pt)
  #raw("#include <type_traits>\n#include <concepts>\ntemplate<class T> requires std::integral<T>\nT add(T a, T b) { return a + b; } // 约束直接说明所需性质\n// 旧标准常用替换失败从候选集移除：\ntemplate<class T, std::enable_if_t<std::is_integral_v<T>, int> = 0>\nT legacy_add(T a, T b) { return a + b; }\n// concepts 错误信息通常更清楚，但重载排序规则不完全等同 SFINAE", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("014  C++20 Ranges 和 View 解决了什么问题？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Ranges 让算法接受范围对象，减少 begin/end 成对传递；view 可把 filter、transform 等步骤惰性组合，遍历时才产生结果，避免中间容器。惰性意味着算法可能重复执行，且许多 view 不拥有元素。返回或保存 view 时要确认底层容器生命周期和迭代器有效性。〔S1，S2〕", size: 9.5pt)
  #raw("#include <ranges>\n#include <vector>\nstd::vector<int> values{1, 2, 3, 4};\nauto odds = values | std::views::filter([](int n) { return n % 2; });\nauto doubled = odds | std::views::transform([](int n) { return n * 2; });\nfor (int n : doubled) consume(n); // 迭代时才过滤/变换，无中间容器\n// view 多数不拥有元素；保存它前要保证 values 和迭代器仍有效", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("015  std::span 是什么？它和 std::vector 有何区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  std::span 是连续内存的非拥有视图，保存地址与长度，适合作为函数参数统一接收数组、vector 或其他连续区间；vector 则拥有可增长的元素存储。span 不负责释放或延长数据生命周期。vector 扩容、被销毁或其他存储失效操作发生后，原 span 可能悬空。〔S2〕", size: 9.5pt)
  #raw("#include <span>\n#include <vector>\nint sum(std::span<const int> values) { int total = 0; for (int x : values) total += x; return total; }\nstd::vector<int> owned{1, 2, 3};\nint result = sum(owned); // span 借用 vector 的连续存储，不复制元素\n// vector 拥有并可扩容；span 只保存地址和长度，不延长生命周期\n// owned 被销毁或扩容后，不得继续用原 span", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("016  std::string_view 有什么优点和生命周期陷阱？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  string_view 以字符指针和长度提供只读视图，可用于解析函数参数而避免构造临时 string。它不拥有字符，data() 后面未必有空字符，不能不加判断就传给只接受 C 字符串的接口。若原 string 析构、修改导致重分配，或临时字符串生命周期结束，view 会失效。〔S2〕", size: 9.5pt)
  #raw("#include <string>\n#include <string_view>\n#include <string_view>\nint parse(std::string_view text) { return parse_digits(text); } // 无需复制字符串\nstd::string owner = \"123\"; std::string_view view = owner;\nint n = parse(view); // 仅在 owner 存活且存储未失效时安全\nstd::string_view dangling() { std::string local = \"bad\"; return local; } // 错误：悬空\n// view 不保证 data() 后有 NUL；传 C API 前要复制/保证终止", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("3.3 Modules、协程与编译期计算", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("017  C++20 Modules 和传统头文件包含有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  传统头文件在预处理阶段把文本复制进每个翻译单元，因此宏会泄漏，重复解析也可能拖慢构建；模块通过 export/import 提供接口，普通宏状态不会像文本包含那样传播。模块接口需先编译成 BMI 等工件，构建系统必须安排依赖顺序。实际兼容性和构建收益取决于编译器、标准库和工程配置。〔S1，S2〕", size: 9.5pt)
  #raw("// math.cppm：模块接口单元\nexport module math;\nexport int add(int a, int b) { return a + b; }\n// client.cpp：import math; 然后调用 add(1, 2)\n// import 提供显式接口且宏不会像文本 include 那样泄漏\n// BMI 需先构建；构建系统必须安排依赖，工具链支持仍需确认", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("018  C++20 协程的基本机制是什么？协程会自动创建线程吗？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  含 co_await、co_yield 或 co_return 的函数可按协程规则编译成可暂停和恢复的状态机。promise_type 定义返回对象与异常行为，awaiter 决定是否挂起以及如何恢复；调用方或调度器负责安排恢复时机。协程本身不创建线程，也不会自动提供 I/O、任务队列或并行调度。〔S1，S2〕", size: 9.5pt)
  #raw("#include <coroutine>\nstruct Task { struct promise_type; std::coroutine_handle<promise_type> handle; };\nTask fetch() { co_await wait_for_io(); co_return; } // 关键字让编译器生成可暂停状态机\n// promise_type 定义返回对象、异常处理和初始/最终挂起行为\n// awaiter 决定是否挂起及恢复方式；调度器/调用方负责何时 resume\n// 协程本身不创建线程，也不自动并发或执行异步 I/O", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("019  std::expected 解决什么问题？它从哪个标准版本开始提供？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  std::expected<T,E>（C++23）保存成功值 T 或错误 E，适合把可预期、可恢复的失败显式放在返回类型中；调用者可检查 has_value，或用 value/error 访问对应分支。与 optional 相比它能携带错误原因，但并不会自动记录日志或替代所有异常。调用方仍应规定错误传播和处理策略。〔S2〕", size: 9.5pt)
  #raw("#include <expected>\n#include <string>\n#include <string_view>\nstd::expected<int, std::string> parse(std::string_view text) { // C++23\n  if (text.empty()) return std::unexpected(std::string(\"empty input\"));\n  return parse_integer(text);\n}\nauto result = parse(\"42\");\nif (result) use(*result); else log(result.error()); // 调用方显式处理错误\n// expected 携带可恢复错误；不会自动日志，也不取代所有异常", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("020  constexpr、consteval 和 constinit 有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  constexpr 可用于满足条件时的编译期求值，也可在运行时调用；consteval 是立即函数，调用必须在常量求值语境中完成。constinit 自 C++20 起要求静态或线程存储期变量经过常量初始化，防止动态初始化顺序问题，但变量仍可被修改。三者含义不同，不能互相替代。〔S2〕", size: 9.5pt)
  #raw("constexpr int twice(int x) { return x * 2; } // 可编译期或运行期求值\nconsteval int fixed(int x) { return x * 2; } // 调用必须立即常量求值\nconstinit int startup = twice(4); // C++20 静态初始化保证，但变量可修改\nint runtime = twice(read_input()); // constexpr 函数也可运行期调用\n// constinit 不能替代 const；三者约束的是不同事情\n// constinit 保证静态/线程存储期变量常量初始化，但不让对象自动 const", lang: "cpp", block: true)
]

#heading(level: 1, outlined: true)[#text("第4章 并发与线程安全", size: 15pt, weight: "bold", fill: rgb("#000000"))]
#heading(level: 2, outlined: true)[#text("4.1 同步原语与线程管理", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  C++ 中如何使用 std::condition_variable 进行线程同步？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  条件变量不保存通知，必须与互斥锁保护的共享谓词一起使用。等待线程用 cv.wait(lock, [&]{ return ready; })，它会在等待时释放锁、被唤醒后重新加锁并循环检查，因而能处理虚假唤醒和通知早到。生产者先持锁更新 ready 或队列，再通知；队列/状态才是事实来源。", size: 9.5pt)
  #raw("#include <condition_variable>\n#include <mutex>\n#include <thread>\nstd::mutex m; std::condition_variable cv; bool ready = false;\nstd::thread worker([&] { std::unique_lock<std::mutex> lock(m);\n  cv.wait(lock, [&] { return ready; }); consume_data(); }); // wait 原子解锁并重查谓词\n{ std::lock_guard<std::mutex> lock(m); ready = true; } // 状态才是事实来源\ncv.notify_one(); worker.join(); // 线程退出前 join，避免悬空引用", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  C++ 中如何实现无锁队列？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  典型无锁队列用 CAS 比较并更新头尾指针或环形缓冲索引，失败时重读状态并重试。设计必须同时保证线性化正确、内存序足够、节点不会在其他线程仍读取时被释放，并处理 ABA。hazard pointer 或 epoch 回收可延迟释放。无锁不等于无等待或更快，优先用经过验证的实现并压力测试。", size: 9.5pt)
  #raw("// 伪代码：Michael–Scott 队列；Node 含 atomic<Node*> next 和 value，先建 dummy\nstd::atomic<Node*> head{dummy}, tail{dummy};\nvoid push(Value v) { Node* n = new Node(std::move(v));\n  for (;;) { Node* t = tail.load(std::memory_order_acquire);\n    Node* next = t->next.load(std::memory_order_acquire);\n    if (t == tail.load() && !next && t->next.compare_exchange_weak(next, n)) break;\n    if (next) tail.compare_exchange_weak(t, next); } // 帮助推进尾指针\n}\n// 省略 dequeue/内存回收：不能在其他线程可能读取时 delete；还须处理 ABA", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  C++ 中如何实现条件同步机制？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先把要等待的条件表示为共享谓词，例如队列非空或可用槽位大于零，再用互斥锁保护谓词和数据，用条件变量等待。wait(lock,pred) 会在醒来后重查条件，避免虚假唤醒。计数型资源可用 C++20 semaphore；通知不是事件计数器，若每次事件都须保留，应把事件放进队列或计数状态。", size: 9.5pt)
  #raw("#include <condition_variable>\nstd::mutex m; std::condition_variable cv; int permits = 0;\nvoid wait_for_work() { std::unique_lock<std::mutex> lock(m);\n  cv.wait(lock, [&] { return permits > 0; }); --permits; }\nvoid signal_work() { { std::lock_guard<std::mutex> lock(m); ++permits; }\n  cv.notify_one(); }\n// wait 用谓词循环处理虚假唤醒；通知本身不保存事件\n// 若要保留每次事件，队列/计数状态须记录它；多线程计数可用 semaphore", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  C++ 中如何避免死锁？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  死锁常由线程以相反顺序持有多把锁造成；可规定全局加锁顺序，或用 std::scoped_lock/std::lock 统一获取多把互斥量。缩小临界区，持锁时避免调用可能回调当前代码的未知函数。try_lock 和超时锁适合特定降级策略，但要定义失败后的恢复逻辑，不能只靠重试掩盖锁顺序问题。", size: 9.5pt)
  #raw("#include <mutex>\nstd::mutex account, inventory;\nvoid transfer() {\n  std::scoped_lock lock(account, inventory); // 一次获取多锁，避免反序死锁\n  update_account(); update_inventory(); // 只在临界区做必要工作\n} // 异常或返回时 RAII 自动解锁\n// 对外回调/未知代码可能反向获取锁；应避免持锁调用\n// 也可规定所有路径按同一全局顺序加锁", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  C++ 中的 std::async 如何创建异步任务？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  std::async 以函数和参数启动异步共享状态并返回 future；若不指定策略，允许选择 launch::async 或 launch::deferred。async 策略可并发运行，deferred 则到 wait/get 时在调用线程执行。future 销毁等细节可能影响等待，且它不是可控线程池；要处理异常、取消需求和任务调度应选更明确的执行框架。", size: 9.5pt)
  #raw("#include <future>\nauto result = std::async(std::launch::async, [] { return compute(); });\n// 指定 async 避免默认策略可能 deferred 到 get 时才在本线程执行\ntry { auto value = result.get(); use(value); }\ncatch (const std::exception& e) { report(e.what()); } // 异常经 future 传播\n// get 只取结果一次；async 不是有界线程池，也不提供强制取消", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  C++ 中的 std::mutex 和 std::lock_guard 是如何工作的？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  std::mutex 通过 lock/unlock 保证同一临界区只有一个线程进入，竞争线程会等待；std::lock_guard 用 RAII 在构造时锁定、离开作用域时解锁，因此异常路径也能释放。多个互斥量需同时获取时可用 std::scoped_lock 避免常见的锁序死锁。互斥量须由成功获取它的线程释放。", size: 9.5pt)
  #raw("#include <mutex>\nstd::mutex m; int balance = 0;\nvoid deposit(int amount) {\n  std::lock_guard<std::mutex> lock(m); // 构造时锁定\n  balance += amount;\n  if (should_throw()) throw Error{}; // 示例：异常也会退出作用域\n} // 析构自动 unlock，避免手动 unlock 漏在异常路径\n// 多把锁用 std::scoped_lock；只由成功获取锁的线程释放", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("007  C++ 中的原子操作（std::atomic）如何使用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  std::atomic<T> 对指定对象上的读改写提供不可分割的原子操作，并用 memory_order 控制与普通内存的同步关系。它只保护这个原子对象，不会自动让余额和版本号等多字段更新成为一个事务。先使用默认顺序一致模型确保正确，再根据发布/获取关系谨慎放宽，并用 happens-before 推理。", size: 9.5pt)
  #raw("#include <atomic>\nstd::atomic<int> requests{0};\nrequests.fetch_add(1, std::memory_order_relaxed); // 只需原子计数，不发布别的数据\nstd::atomic<bool> ready{false}; int payload = 0;\n// 若用 ready 发布 payload，应使用 release store / acquire load\n// atomic 只保护自身对象；余额与版本号等多字段不自动构成事务\n// 正确性优先用默认 seq_cst，再按同步关系优化内存序", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("008  C++ 中的线程局部存储（Thread Local Storage）是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  thread_local 为每个线程创建独立实例，适合线程本地缓存、错误状态或临时上下文，避免多个线程直接写同一个变量。它并不会同步线程间共享数据；线程退出时其对象通常会析构。线程局部对象若由动态库提供，析构和卸载行为还可能受平台运行时规则影响。", size: 9.5pt)
  #raw("#include <string>\n#include <string_view>\nthread_local std::string scratch; // 每个线程都有独立字符串\nvoid parse(std::string_view input) { scratch.assign(input); process(scratch); }\n// 两线程调用时 scratch 不共享，避免为这份临时状态加锁\nstd::string shared; // 普通全局变量仍需同步保护\n// 线程退出时会析构自己的 thread_local 对象\n// TLS 不是跨线程通信方式；动态库卸载还需考虑平台运行时行为", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("009  C++ 中的线程（std::thread）如何创建和管理？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  构造 std::thread 时线程函数即可开始运行；对象销毁前必须 join 等待它结束，或 detach 让其独立运行，否则析构会调用 std::terminate。优先用具有清理保证的 RAII 或 C++20 jthread。按引用传递的参数和捕获对象必须活得比工作线程久，detach 尤其容易造成悬空访问。", size: 9.5pt)
  #raw("#include <exception>\n#include <thread>\nstd::thread worker([] { try { do_work(); } catch (...) { report_failure(); } });\n// 线程函数不可让异常逃逸到线程入口，否则会 terminate\nif (worker.joinable()) worker.join(); // 返回前确保工作结束\n// 所有引用捕获的数据都必须比 worker 活得久\n// detach 会让生命周期难以证明；优先 RAII 管理或 C++20 std::jthread", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("010  C++ 中的读写锁（std::shared_mutex）是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  std::shared_mutex 允许多个线程同时持有共享锁读取，同一时刻写锁独占；shared_lock 用于读，unique_lock 用于写。它适合读多写少且读临界区足以覆盖加锁成本的场景。标准不保证对读写公平的具体策略，写者可能等待；不能持有读锁后再随意升级成写锁，应显式设计锁转换。", size: 9.5pt)
  #raw("#include <shared_mutex>\nstd::shared_mutex data_mutex; Data data;\nData snapshot() { std::shared_lock<std::shared_mutex> lock(data_mutex); return data; }\nvoid update(Data next) { std::unique_lock<std::shared_mutex> lock(data_mutex); data = std::move(next); }\n// 多个 reader 可同时读，writer 独占；锁覆盖整个数据访问\n// 写多时读写锁开销/等待可能不划算；标准不保证公平策略\n// 不要假设能安全地从共享锁直接升级到独占锁", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("4.2 并发任务组织", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("011  如何使用 C++ 实现生产者-消费者模型？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  用互斥量保护任务队列，用两个条件谓词表示队列非空和未达到容量上限。生产者在锁内检查容量并入队，再通知消费者；消费者取走任务后通知生产者，执行任务要放在锁外。关闭时需唤醒所有等待者并让谓词包含停止状态，明确满队列是阻塞、拒绝还是丢弃。", size: 9.5pt)
  #raw("#include <condition_variable>\n#include <cstddef>\n#include <mutex>\n#include <queue>\n#include <utility>\nstd::mutex m; std::condition_variable not_empty, not_full;\nstd::queue<Job> q; bool stopping = false; constexpr std::size_t capacity = 8;\nvoid produce(Job job) { std::unique_lock<std::mutex> lk(m);\n  not_full.wait(lk, [] { return q.size() < capacity || stopping; });\n  if (stopping) return; q.push(std::move(job)); lk.unlock(); not_empty.notify_one(); }\nvoid consume() { std::unique_lock<std::mutex> lk(m);\n  not_empty.wait(lk, [] { return !q.empty() || stopping; });\n  if (q.empty()) return; Job job = std::move(q.front()); q.pop(); lk.unlock();\n  not_full.notify_one(); run(job); } // 锁外执行；shutdown 要唤醒等待者", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("012  如何实现线程池？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  线程池通常包含固定或可调数量的工作线程、有界任务队列、互斥量和条件变量；工作线程醒来后取出任务，在不持队列锁的情况下执行。接口需定义队列满时的拒绝/阻塞、任务异常如何回传、关闭时是否排空任务。析构或 shutdown 应设置停止状态、通知全部线程并 join，保证依赖资源仍存活。", size: 9.5pt)
  #raw("// 线程池伪代码：队列由 mutex 保护，cv 表示“有任务或停止”\nvoid worker_loop() { for (;;) { Task task;\n  { std::unique_lock<std::mutex> lk(m);\n    cv.wait(lk, [&] { return stopping || !tasks.empty(); });\n    if (stopping && tasks.empty()) return;\n    task = std::move(tasks.front()); tasks.pop(); }\n  try { task(); } catch (...) { report_task_error(); } // 锁外执行\n} }\nvoid shutdown() { set_stopping(); cv.notify_all(); join_all(); }\n// API 还需规定队列满、异常传回与“排空/丢弃”策略", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("4.3 内存模型与无锁协作", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("013  std::memory_order 中 relaxed、acquire/release 和 seq_cst 的差异是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  relaxed 保证原子操作自身不可分割，但不建立与其他普通读写的同步。release store 与读到该值的 acquire load 可建立跨线程同步，从而让发布前的普通写对获取方可见；seq_cst 还要求顺序一致操作处在满足规则的单一全序中。选择内存序应先写出所需 happens-before 关系，再验证程序。〔S2〕", size: 9.5pt)
  #raw("#include <atomic>\n#include <thread>\nint payload = 0; std::atomic<bool> ready{false};\nstd::thread producer([&] { payload = 42; ready.store(true, std::memory_order_release); });\nwhile (!ready.load(std::memory_order_acquire)) {} // 读到 release 后同步\nint value = payload; // producer 对 payload 的写 happens-before 此读\nproducer.join(); // join 管理生命周期；不能用 volatile 代替 atomic", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("014  std::jthread 和 std::thread 有什么不同？stop_token 能强制终止线程吗？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  std::thread 若析构时仍 joinable 会调用 terminate；std::jthread 析构时会请求停止，并在仍可 join 时等待线程结束。stop_token 是协作信号，函数需主动检查、使用可停止等待或注册回调；它不会强杀线程，也不会自动打断任意阻塞系统调用。线程必须保证停止请求后最终可退出。〔S2〕", size: 9.5pt)
  #raw("#include <thread>\nstd::jthread worker([](std::stop_token stop) {\n  while (!stop.stop_requested()) process_one(); // 合作式检查停止请求\n});\nworker.request_stop(); // 只发信号，不会强制杀掉线程\n// jthread 析构会请求停止并 join；线程体必须能最终退出\n// stop_token 不会自动中断任意阻塞调用，等待应使用可停止机制", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("015  std::latch 和 std::barrier 如何选择？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  latch 是一次性计数门闩，多个线程 count_down 后计数归零，等待者继续，之后不能重置。barrier 用于重复阶段：每一轮参与者到齐后进入下一阶段，可在阶段切换时执行 completion 函数。一次任务启动汇合适合 latch，图像分块处理等多轮同步阶段适合 barrier。〔S2〕", size: 9.5pt)
  #raw("#include <latch>\nstd::latch start_line(4); // 一次性门闩，4 个参与者汇合后开放\nvoid worker() { prepare(); start_line.count_down(); start_line.wait(); run_phase(); }\n// 下一轮不可重置 latch；多轮阶段同步改用 std::barrier\n// barrier 每轮参与者到齐后进入下一阶段，还可执行 completion 回调\n// 启动后固定参与者数量的一次汇合选 latch；重复算法阶段选 barrier", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("016  C++20 atomic::wait/notify 与忙等轮询有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  atomic::wait(old) 在原子值仍等于 old 时阻塞，值发生变化并收到通知后才重新检查；notify_one/all 只唤醒等待者，不代替状态更新。它相比忙等减少 CPU 空转，适合状态等待。仍要用循环检查应用谓词，且值变化后又回到 old 的 ABA 情况可能不会被观察到。〔S2〕", size: 9.5pt)
  #raw("#include <atomic>\nstd::atomic<int> state{0};\nvoid waiter() { while (state.load() == 0) state.wait(0); // 值未变时阻塞\n  continue_work(); }\nvoid signal() { state.store(1); state.notify_one(); } // 先更新状态，再唤醒\n// notify 不是事件计数；谓词/值是状态来源，醒来后仍要重查\n// 相比忙等减少 CPU 空转；若值快速变回旧值，可能看不到中间状态", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("017  数据竞争（data race）和竞态条件（race condition）有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  数据竞争是 C++ 内存模型中的特定情形：不同线程对同一内存位置发生未排序的冲突访问，至少一个为非原子写，结果是未定义行为。竞态条件是更广的逻辑问题，例如两个线程各自原子地检查和扣库存，仍可能因检查与更新未组成整体操作而超卖。消除数据竞争不等于业务逻辑正确。〔S2〕", size: 9.5pt)
  #raw("std::atomic<int> stock{1};\n// 两次原子操作各自安全，但“检查再扣减”不是一个原子事务\nif (stock.load() > 0) stock.fetch_sub(1); // 两线程都可能先读到 1，导致变负\n// 用 CAS 循环，或把检查与更新放进同一把 mutex\n// 数据竞争会导致 C++ 未定义行为；竞态条件还包括这种逻辑错误\n// 修掉 data race 后仍要验证业务不变量", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("018  std::atomic_ref 有什么用途？使用时要注意什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  std::atomic_ref<T> 可在已有 T 对象上提供原子读改写，适合无法把数据结构成员声明为 atomic 的场景。目标对象地址须满足 atomic_ref<T>::required_alignment；atomic_ref 存续期间，对该对象的并发访问须符合原子访问约束，不能一边经 atomic_ref 写、一边普通非原子读。被引用对象也必须始终存活。〔S2〕", size: 9.5pt)
  #raw("#include <atomic>\nstruct Counter { alignas(std::atomic_ref<int>::required_alignment) int value = 0; };\nCounter counter;\nstd::atomic_ref<int> atomic_value(counter.value); // 在已有对象上原子操作\natomic_value.fetch_add(1, std::memory_order_relaxed);\n// atomic_ref 存活期间，禁止对 value 并发做普通非原子读写\n// Counter 和成员必须活到所有 atomic_ref 使用完；还需满足对齐要求", lang: "cpp", block: true)
]

#heading(level: 1, outlined: true)[#text("第5章 性能与工程实践", size: 15pt, weight: "bold", fill: rgb("#000000"))]
#heading(level: 2, outlined: true)[#text("5.1 性能测量与基础优化", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  C++ 中如何提高程序的执行效率？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先定义目标指标，如吞吐、尾延迟或内存占用，再用采样 profiler 和基准测试定位真实热点。通常优先降低算法复杂度、减少重复工作和不必要分配，再检查数据局部性与并行度。每次只改一个因素，在相同编译选项和代表性数据上复测，避免把微基准收益误认为端到端提升。", size: 9.5pt)
  #raw("#include <chrono>\n#include <chrono>\nauto begin = std::chrono::steady_clock::now();\nfor (int i = 0; i < repetitions; ++i) run_representative_work();\nauto elapsed = std::chrono::steady_clock::now() - begin;\nreport(elapsed); // 先记录正确性、吞吐/尾延迟/内存等目标指标\n// 用 profiler 找热点，再一次只改一个因素并重复测量\n// 固定编译选项和输入；微基准收益须用端到端负载验证", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  C++ 中如何避免不必要的内存拷贝？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  接口只读大对象时可用 const T& 或 span 借用，所有权需要转移时用值传递配合移动；从函数按值返回通常可由编译器消除拷贝，不必为避免复制而返回局部对象引用。emplace 只有在容器内直接构造确实省步骤时才可能有收益。先测量，并确保引用不会超过原对象生命周期。", size: 9.5pt)
  #raw("#include <vector>\nvoid inspect(const std::vector<Record>& records) { // 只读借用，不复制大容器\n  for (const Record& record : records) inspect_one(record);\n}\nstd::vector<Record> make_records() { std::vector<Record> result;\n  fill(result); return result; // 返回局部值可做 NRVO，不要返回局部引用\n}\nvoid take_ownership(std::vector<Record> records) { consume(std::move(records)); }\n// 借用用引用/span；真正转移所有权时用值加移动，并检查生命周期", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  C++ 中的 SIMD（单指令多数据）优化如何实现？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  SIMD 将同一条运算应用于一组独立数据，例如同时对多个像素做亮度变换。先采用连续、对齐友好的数据布局并查看优化报告，让编译器自动向量化；确有瓶颈时再用 intrinsic 或 SIMD 库。分支、尾部余数、内存带宽和数据对齐都会影响收益，需在目标 CPU 上测基准。", size: 9.5pt)
  #raw("#include <cstddef>\n// 连续数组、彼此独立的运算利于编译器自动向量化\nfor (std::size_t i = 0; i < count; ++i) output[i] = input[i] * scale + bias;\n// 先确认无重叠/别名假设，查看编译器向量化报告\n// 对齐、尾部元素、分支和内存带宽都会影响收益\n// 手写 intrinsic 前，在目标 CPU 和代表性数据上比较吞吐\n// SIMD 只适合彼此独立且能批量执行的工作", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  C++ 中的内联函数（inline）如何优化性能？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  inline 不要求编译器展开调用；编译器会根据优化级别、函数大小、调用频率和跨模块信息决定是否内联。内联可消除调用并暴露常量传播机会，但过多展开会增大代码、损害指令缓存。它还允许符合 ODR 的函数定义出现在多个翻译单元，性能效果应以生成代码和基准为准。", size: 9.5pt)
  #raw("// 头文件中的定义可标 inline 以符合多翻译单元 ODR\ninline int normalize(int x) { return x < 0 ? 0 : x; }\nint result = normalize(input); // 编译器仍可决定保留普通调用\n// 内联可省调用并暴露常量传播；过度展开增大代码和指令缓存压力\n// 查看优化后汇编与基准，不要把 inline 当性能保证\n// ODR 允许定义跨单元出现，与优化器是否展开是两回事", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  C++ 中的循环展开（Loop Unrolling）是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  循环展开把多次迭代的工作写在同一循环体中，可能减少循环计数和分支开销，并暴露更多独立指令供处理器并行执行。但展开过多会增加代码体积、寄存器压力和指令缓存未命中，尾部处理也更复杂。现代编译器常能自动决定展开程度，手动优化前应检查汇编并实测。", size: 9.5pt)
  #raw("#include <cstddef>\nfor (std::size_t i = 0; i + 3 < n; i += 4) { // 一次处理四项\n  sum += values[i]; sum += values[i + 1];\n  sum += values[i + 2]; sum += values[i + 3];\n}\nfor (std::size_t i = n - n % 4; i < n; ++i) sum += values[i]; // 尾部\n// 展开可能减少分支，但会增加代码体积/寄存器压力\n// 现代编译器常能自动展开；先看汇编和真实基准", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  C++ 中的线程开销如何优化？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  短任务反复创建和销毁线程会产生调度与栈初始化开销，可用线程池、批处理或把工作合并成较粗粒度任务。还要测量锁竞争、上下文切换、线程数和任务队列延迟，避免并行度超过 CPU 或 I/O 能力。线程池会增加队列和关闭管理复杂度，按吞吐及尾延迟验证收益。", size: 9.5pt)
  #raw("// 伪代码：启动时创建固定工作线程，后续任务复用线程\nThreadPool pool(worker_count);\nfor (Batch batch : split_into_coarse_batches(input))\n  pool.submit([batch] { process(batch); });\npool.wait_idle(); // 完成后继续汇总；析构前先排空并 join\n// 合并过小任务可降低调度/分配开销；队列、停止和异常需定义\n// 线程太多会增加切换和争用，按吞吐与尾延迟测量", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("5.2 算法、缓存与 I/O", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("007  如何优化 C++ 中的算法复杂度？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先分析输入规模和操作比例，再选择算法与容器：unordered_map 查找平均期望 O(1) 但最坏可达 O(n)，map 为 O(log n) 且有序；list 只有在已持有位置迭代器时插删才便宜，查找仍是 O(n)。双指针、滑动窗口和二分需满足各自的数据条件，动态规划用于消除重复子问题；用复杂度和实测共同评估。", size: 9.5pt)
  #raw("#include <algorithm>\n#include <list>\n#include <map>\n#include <unordered_map>\nstd::unordered_map<Key, Value> by_key; // 平均期望 O(1)，最坏 O(n)\nstd::map<Key, Value> ordered; // 有序查找/插入 O(log n)\nstd::list<Value> chain; // 已有迭代器时插删便宜，按值查找仍 O(n)\n// 二分需有序；双指针/滑窗需满足单调条件，DP 消除重复子问题\n// 依输入规模和操作比例选结构，再用代表性负载验证", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("008  如何优化 C++ 的循环和内存访问？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  顺序遍历连续存储通常更利于缓存预取，指针追踪则可能造成随机内存访问。可根据访问模式选择 AoS 或 SoA、循环融合或分块，让工作集适合缓存；避免盲目重排会影响可读性和 ABI。用硬件计数器或 profiler 确认 cache miss、带宽或分支确实是瓶颈，再比较改动前后的目标负载。", size: 9.5pt)
  #raw("#include <cstddef>\n// 行主序矩阵按行扫描，可顺着连续地址访问\nfor (std::size_t r = 0; r < rows; ++r)\n  for (std::size_t c = 0; c < cols; ++c) sum += matrix[r * cols + c];\n// 分块让工作集更可能留在缓存；AoS 适合逐对象处理、SoA 适合批量单字段\n// 循环融合可减少重复读写，也可能扩大工作集或降低可读性\n// 用 cache-miss/带宽计数确认瓶颈，别为 ABI 贸然重排公开结构", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("009  如何优化 C++ 程序中的 I/O 性能？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  文本或文件 I/O 可通过批量读写和合适缓冲减少系统调用；C++ iostream 与 stdio 混用时，关闭 sync_with_stdio 后不要再假设两套缓冲顺序一致，交互输入还需按需 flush。setvbuf 只配置 C 流缓冲，并应在该流执行 I/O 前调用。std::async 只是调度任务，不会把阻塞文件调用变成真正异步 I/O。", size: 9.5pt)
  #raw("#include <iostream>\n#include <vector>\nint main() {\n  std::ios::sync_with_stdio(false); std::cin.tie(nullptr); // 所有 I/O 前调用\n  std::vector<int> values; int x;\n  while (std::cin >> x) values.push_back(x); // 批量缓冲输入\n  std::cout << values.size() << '\\n';\n} // 关闭 sync 后勿假设与 printf 的缓冲顺序；交互场景需 flush\n// 异步调度不等于内核异步 I/O；按平台选缓冲/批量接口", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("010  如何使用缓存优化提高 C++ 程序性能？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  缓存优化利用时间局部性（近期访问可能再次访问）和空间局部性（相邻数据可能一并使用）。连续访问、减少无用字段加载通常有利；AoS 适合一次处理单个完整对象，SoA 更适合对大量对象的单一字段批量运算。缓存行大小因处理器而异，伪共享与工作集大小需用硬件计数器和真实负载确认。", size: 9.5pt)
  #raw("#include <cstddef>\n#include <vector>\nstruct AoS { float x, y, z; };\nstd::vector<AoS> points(count); // 整个对象处理时 AoS 连续\nstd::vector<float> x(count), y(count), z(count); // 批量改 x 时 SoA 少加载无关字段\nfor (std::size_t i = 0; i < count; ++i) x[i] *= scale; // 空间局部性\n// 重用近期数据利用时间局部性；相邻数据利用空间局部性\n// 缓存行和伪共享依硬件；用工作集与硬件计数器验证", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("5.3 链接期优化", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("011  LTO 和 PGO 分别做什么？可以一起使用吗？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  LTO 在链接阶段利用多个翻译单元的中间表示做跨单元优化；PGO 则用代表性运行负载采集的分支和调用频率指导优化。两者提供的信息不同，可组合使用，但会增加构建和采集步骤；训练负载偏离生产会误导优化。部署前应在目标机器和实际工作负载上比较吞吐、延迟和体积。〔S3〕", size: 9.5pt)
  #raw("// PGO 先用代表性负载生成 profile，再用 profile 构建部署版本\n// CXXFLAGS += -fprofile-generate\n// run representative_workload\n// CXXFLAGS += -fprofile-use -flto\n// LTO 在链接时跨单元优化，PGO 按运行频率指导分支/调用优化\n// 两者可组合；训练数据偏离生产会误导优化\n// 比较实际延迟、吞吐和体积后再决定", lang: "cpp", block: true)
]

#heading(level: 1, outlined: true)[#text("第6章 编译、链接与构建", size: 15pt, weight: "bold", fill: rgb("#000000"))]
#heading(level: 2, outlined: true)[#text("6.1 头文件与项目组织", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  #pragma once 和 #include guards 有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Include guard 是标准预处理器写法：定义唯一宏，后续重复包含时跳过文件内容；#pragma once 更简短，但属于编译器广泛支持的扩展，并非标准指令。两者目的都是避免同一翻译单元重复展开，并不解决两个不同文件意外使用相同 guard 名的问题。团队应采用一致且唯一的 guard 命名规范。", size: 9.5pt)
  #raw("// 可移植的 include guard\n#ifndef PROJECT_NET_SOCKET_HPP\n#define PROJECT_NET_SOCKET_HPP\nstruct Socket { void close(); };\n#endif\n// #pragma once 更短且主流编译器支持，但属于实现扩展\n// 二者都防止同一翻译单元重复展开；guard 宏必须在工程内唯一\n// 它们不消除真正的循环依赖", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  C++ 中使用 -fPIC 编译选项有什么作用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  -fPIC 让编译器生成适合装载到不同虚拟地址的代码，常用于 Linux 等平台的共享库；静态目标若之后可能被链接进共享库，也可能需要以 PIC 编译。其实现会通过平台相关寻址方式访问全局数据，可能有微小成本。具体选项和是否必需依目标平台、架构与链接器而异。", size: 9.5pt)
  #raw("// 共享库里的目标文件通常需位置无关代码\n// g++ -fPIC -c lib.cpp -o lib.o\n// g++ -shared lib.o -o libexample.so\n// -fPIC 使用平台相关寻址方式，适用于多地址装载\n// 静态库以后若可能被链接进共享库，也可能要编成 PIC\n// 是否需要/性能影响依架构和工具链，Windows 选项不同", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  C++ 中动态库的符号表（Symbol Table）是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  动态符号表列出动态链接器需要查找的导出符号及相关绑定信息；普通完整符号表还可能包含调试或内部符号，二者用途不同。可通过默认隐藏可见性并显式标记公共 API 来减少 ABI 暴露，再用 readelf -Ws 或 nm -D 检查导出结果。符号导出变更可能影响运行时兼容性。", size: 9.5pt)
  #raw("// 默认隐藏实现符号，只导出有意公开的 ABI\n#if defined(__GNUC__)\n__attribute__((visibility(\"default\"))) void public_api();\n#endif\n// readelf -Ws libexample.so 查看 ELF 符号表\n// nm -D libexample.so 只查看动态符号\n// 普通符号表也可能包含调试/内部符号；导出集是 ABI 面的一部分\n// visibility 属性是工具链扩展，跨平台需定义统一宏", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  C++ 中的 attribute((constructor)) 和 attribute((destructor)) 有何作用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  __attribute__((constructor)) 和 destructor 是 GCC/Clang 等工具链支持的扩展，可让函数在程序常规入口前或退出阶段运行；它们不是标准 C++，跨平台行为和优先级应查对应编译器文档。此类初始化顺序不易表达依赖关系，也可能遇到动态库卸载问题。通常应使用静态局部对象、RAII 或显式启动/关闭接口。", size: 9.5pt)
  #raw("#if defined(__GNUC__)\n__attribute__((constructor)) static void before_main() { init_global(); }\n__attribute__((destructor)) static void after_main() { shutdown_global(); }\n#endif\n// 这是 GCC/Clang 扩展，不是标准 C++，库卸载和顺序依平台\n// 多个初始化器之间的依赖难表达，可能遇到静态初始化顺序问题\n// 普通程序优先使用 RAII、函数内 static 或显式启动/停止接口", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  C++ 中的前向声明（Forward Declaration）是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  前向声明只让编译器知道类型或函数名称存在，不提供类成员、布局或大小。声明指针、引用、函数参数和返回类型时经常足够；定义按值成员、继承、访问成员或实例化需要完整布局的操作时必须包含定义。把非必要 include 移到源文件可降低耦合和重编译范围。", size: 9.5pt)
  #raw("// node.hpp：若只声明指针/引用，可避免包含完整定义\nclass Node;\nvoid visit(const Node& node);\nclass Owner { Node* node_; }; // 指针成员允许不完整类型\n// node.cpp 再 #include \"node_definition.hpp\" 访问 Node 成员\n// 按值成员、继承、sizeof 或内联访问成员需要完整类型定义", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  C++ 多文件项目中，头文件与源文件如何组织？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  头文件放需要被调用方看到的声明、公共类型和模板定义；非模板实现通常放源文件，并在一个目标文件中定义一次。每个头文件应自包含并使用 guard；前向声明可减少依赖，但使用完整类型的位置必须 include 定义。模板若要在调用处实例化，通常需要可见定义，模块化项目也应明确接口依赖。", size: 9.5pt)
  #raw("// widget.hpp：向调用方暴露声明和所需完整类型\n#ifndef WIDGET_HPP\n#define WIDGET_HPP\nclass Widget { public: void run(); };\n#endif\n// widget.cpp：#include \"widget.hpp\" 后定义 void Widget::run() { ... }\n// 每个头文件应可自包含；非模板实现一般只在一个源文件定义\n// 模板实现通常需在实例化点可见；前向声明可降低无关重编译", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("6.2 编译、链接与库", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("007  C++ 源文件如何经过编译生成可执行文件？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  典型工具链依次预处理宏和 include、编译语法语义并生成汇编、汇编成目标文件，最后由链接器解析符号、重定位并组合库生成可执行文件。实际工具可能把阶段封装在一次命令中。编译期错误多看源文件和头文件；未定义符号、重复定义多在链接阶段出现。启用 LTO 时链接器还可做跨单元优化。", size: 9.5pt)
  #raw("// 逐阶段查看工具链输出（命令以 GCC/Clang 为例）\n// c++ -E app.cpp -o app.ii     预处理宏与 include\n// c++ -S app.ii -o app.s       编译为汇编\n// c++ -c app.s -o app.o        汇编成目标文件\n// c++ app.o lib.o -o app       链接符号、重定位并生成可执行文件\n// 源/头错误看编译阶段；未定义/重复符号看链接阶段，LTO 会延伸优化", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("008  extern 在多文件程序中如何声明共享变量？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  在头文件写 extern int count; 这通常只是声明，不分配存储；在一个且仅一个源文件写 int count = 0; 才是定义，其他文件包含声明后可引用。C++17 起也可用 inline 变量在头文件定义共享实体。全局变量初始化顺序可能跨翻译单元不确定，应尽量封装并控制依赖。", size: 9.5pt)
  #raw("// shared.hpp：仅声明，不分配定义\nextern int shared_count;\n// state.cpp：程序中恰好一个定义\nint shared_count = 0;\n// use.cpp：包含声明后可访问 shared_count\nvoid increment() { ++shared_count; } // 多线程时仍需同步\n// C++17 可用 inline int shared_count = 0; 放头文件共享一个实体", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("009  static 变量在头文件中的作用是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  命名空间作用域 static 变量具有内部链接；如果定义在头文件，每个包含它的翻译单元都会得到自己的独立副本，可能导致状态不共享且增加存储。需要程序级共享对象时，可在头文件 extern 声明、单个源文件定义；C++17 也可使用 inline 变量，仍需考虑初始化顺序和并发访问。", size: 9.5pt)
  #raw("// counter.hpp\nstatic int counter = 0; // 每个包含该头的翻译单元各自一份\n// a.cpp 和 b.cpp 各 include 后，修改的是不同对象\n// 需要一个程序级共享实体时：extern 声明 + 单个源文件定义\n// 或 C++17 inline int counter = 0; 允许头文件中的同一实体定义\n// 全局共享仍需考虑初始化顺序和并发访问", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("010  头文件的依赖关系如何避免循环引用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  循环引用通常是 A.h 包含 B.h、B.h 又包含 A.h，导致类型定义依赖纠缠。若一个类仅通过指针或引用提及另一类，可在头文件前向声明并把实际 include 放到源文件；成员按值存放、继承或内联实现访问成员时仍需完整定义。Include guard 防止重复展开，但不会消除真正的依赖循环。", size: 9.5pt)
  #raw("// a.hpp：只通过引用提及 B，可前向声明\nclass B;\nclass A { public: void use(const B&); private: B* b_; };\n// a.cpp 再 include b.hpp 并定义 A::use，因访问成员需要完整类型\n// 如果 A 按值保存 B、继承 B 或内联访问 B 的字段，则前向声明不够\n// include guard 防重复展开，不会消除真实依赖循环", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("011  如何定位常见的 C++ 链接错误？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先看链接器报错中的符号和目标文件：undefined reference 常表示实现未参与链接、签名/命名空间不匹配或库缺失；multiple definition 表示非 inline 实体被重复定义；找不到库则核对搜索路径及平台前缀后缀。用 nm/readelf/dumpbin 查符号，并打开详细链接命令确认实际输入。", size: 9.5pt)
  #raw("// undefined reference: 实现源文件/库未链接，或声明签名、命名空间不一致\n// nm -C app.o libpart.a | rg 'WantedSymbol' 检查符号是否存在\n// g++ app.o libpart.a -o app   # 并确认静态库位于引用者之后\n// multiple definition: 查找重复定义，头文件函数考虑 inline\n// 打开构建系统 verbose 命令核对实际输入文件、库路径和链接顺序\n// 符号名存在但 ABI 不匹配时核对编译器/运行库/宏设置", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("012  如何调试链接错误？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先分类错误：undefined reference 查定义是否编译入目标和签名是否完全匹配；multiple definition 查头文件中的非 inline 定义；找不到库查库路径、名称及链接顺序；ABI 错误查编译器、运行库和宏配置。用构建系统输出完整命令，再用 nm、dumpbin 或链接器 map 文件追踪符号来源。", size: 9.5pt)
  #raw("// header.hpp：多翻译单元可见的相同函数定义要满足 inline 规则\ninline int helper(int x) { return x + 1; }\n// 若移除 inline 且 header 被 a.cpp、b.cpp 同时包含，会重复定义\n// undefined reference 则相反：只有声明，定义没有进入链接输入\n// 用 nm -C 查符号，构建 verbose 输出确认哪个 .o/.a 真正参与链接\n// 链接成功也不能证明 ODR 一定满足", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("013  静态库和动态库的链接方式有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  静态库通常是目标文件归档，链接时把被需要的目标代码复制进最终产物，部署较直接但更新一般要重新链接，体积和重复代码可能增加。动态库由加载器在运行时装入，多个进程可共享其映射且库可单独升级，但需正确部署搜索路径、依赖和兼容 ABI。两种方式的实际收益依平台及链接选项而异。", size: 9.5pt)
  #raw("// 静态库：归档目标文件，所需代码通常复制进最终程序\n// ar rcs libmath.a add.o\n// c++ app.o -L. -lmath -o app\n// 动态库：运行时加载，可共享映射/单独升级，但要部署依赖和搜索路径\n// c++ -fPIC -shared add.cpp -o libmath.so\n// c++ app.o -L. -lmath -Wl,-rpath,'$ORIGIN' -o app\n// 部署便利、体积、ABI 兼容性和更新方式按平台权衡", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("6.3 ODR 与 ABI", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("014  C++ 的 ODR（单一定义规则）是什么？违反后一定会有链接错误吗？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  ODR 要求程序中需要定义的实体满足唯一性或特定例外规则；模板、类和 inline 函数可在多个翻译单元定义，但通常须遵守相同 token 序列及一致查找等条件。违规则可能是链接错误，也可能属于无需诊断的 ill-formed 程序，导致不同翻译单元行为不一致。链接成功不能证明满足 ODR。〔S2〕", size: 9.5pt)
  #raw("// C++17 inline 变量允许同一头文件定义出现在多个翻译单元\ninline constexpr int retry_limit = 4;\n// 对应的定义必须满足 ODR 要求，例如 token 序列和名字查找一致\n// 普通非 inline 函数/变量若定义多次通常会链接失败\n// 某些 ODR 违规无需诊断，可能链接成功却让不同单元行为不一致\n// 所以“链接通过”不是 ODR 正确性的证明", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("015  C++ ABI 是什么？它和源代码兼容有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  ABI 描述已编译模块如何互通，例如符号修饰、调用约定、参数传递、对象布局、虚函数分派和异常处理。源代码兼容关注代码重新编译后能否通过；ABI 兼容关注旧二进制能否不重编译就与新库协作。改变公开类大小、虚函数顺序或编译器运行库常会破坏 ABI，需版本策略。〔S4〕", size: 9.5pt)
  #raw("// 稳定 C ABI 示例：C/C++ 两侧共享不透明句柄，不暴露类布局\nextern \"C\" { struct Engine;\n  Engine* engine_create();\n  void engine_destroy(Engine*);\n  int engine_run(Engine*, const char* input);\n}\n// 源码兼容看重新编译后能否调用；ABI 兼容看旧二进制能否继续链接运行\n// 改公开类大小、虚函数顺序、调用约定或运行库可能破坏 ABI", lang: "cpp", block: true)
]

#heading(level: 1, outlined: true)[#text("第7章 操作系统与 Linux", size: 15pt, weight: "bold", fill: rgb("#000000"))]
#heading(level: 2, outlined: true)[#text("7.1 文件、权限与进程", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  Linux 文件权限 755 和 644 表示什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  755 按八进制拆成所有者 7、组 5、其他人 5，分别对应 rwx、r-x、r-x；644 则是 rw-、r--、r--。对普通文件，x 表示可执行；对目录，x 表示可搜索并穿越，缺少 r 时仍可能已知名称后访问条目。目录的写权限通常还要结合 x 才能创建或删除目录项。 设置权限时还要结合 umask；特殊位 setuid、setgid、sticky 会改变普通权限位的解释。", size: 9.5pt)
  #raw("mode_t requested = 0755; // owner/group/other：rwx、r-x、r-x\ncreate_file(path, requested); // 创建时内核按 requested & ~process_umask 过滤\nchmod(path, requested); // chmod 修改既有文件模式，不受 umask 再过滤\n// 普通文件的 x 表示可执行；目录的 x 表示可搜索/穿越\n// 目录中删除目录项通常需目录同时有 w+x，和目标文件权限不同\n// setuid/setgid/sticky 是额外语义位；设置时仍需按安全策略检查", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  Linux 文件系统中的 inode 保存什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  inode 记录权限、所有者、大小、时间戳、链接计数及数据块定位等元信息，文件名保存在目录项中，因此可有多个名字指向同一 inode。硬链接共享 inode 和内容，删除一个名字只减少链接计数；符号链接有自己的 inode，内容是目标路径，目标可跨文件系统且可能失效。 inode 编号只在同一文件系统内有意义；文件系统卸载后，挂载点名称也会影响路径解析。", size: 9.5pt)
  #raw("struct Inode { Permission mode; Owner uid; Size bytes; BlockMap data; int links; };\n// 目录项保存 name -> inode；文件名不是 inode 的一部分\nlink(\"a\", \"b\"); // 两个名字共享 inode 和内容\nunlink(\"a\"); // 链接计数减一；另一个名字仍可访问\n// 最后一个目录链接删除后，若仍有打开句柄，数据也要等关闭后回收\nsymlink(\"missing-or-any-path\", \"shortcut\"); // 符号链接有自己的 inode，可悬空\n// inode 编号只在本文件系统内有意义；路径解析还受挂载点影响", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  Linux 进程有哪些常见状态？阻塞态何时出现？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Linux 常见可运行/运行、可中断睡眠、不可中断睡眠、停止或跟踪以及僵尸状态；ps 中的字母是状态的简写。等待磁盘 I/O 等不可立即完成的条件时进程睡眠，普通信号通常不能唤醒 D 态任务。退出后僵尸只保留退出码等信息，父进程 wait 系列调用回收它。 可用 ps 的 STAT 字段初步判断状态，持续 D 态需结合内核栈和 I/O 设备排查。", size: 9.5pt)
  #raw("state = inspect_with_ps_STAT(pid);\nif (state == \"R\") schedule_or_running(); // 可运行/运行\nif (state == \"S\") wait_interruptible_event(); // 可被普通信号打断的睡眠\nif (state == \"D\") inspect_kernel_stack_and_io(); // 常见于不可中断 I/O 等待\nif (state == \"T\") inspect_job_control_or_debugger();\nif (state == \"Z\") parent.waitpid(pid); // 僵尸只留退出信息，等父进程回收\n// 持续 D 态查设备/I/O；普通信号通常不能立即唤醒 D 态任务。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  fork() 与 exec() 分别做什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  fork 创建逻辑上独立的子进程，父进程得到子 PID、子进程得到 0，失败返回 -1；通常先通过写时复制共享物理页。exec 系列在当前进程中装入新程序映像，PID 保持不变，成功不会返回，失败才返回错误。典型启动流程是 fork 后在子进程 exec、父进程 wait。 需要子进程退出码时父进程应 wait，长期不回收会积累僵尸条目。", size: 9.5pt)
  #raw("pid = fork();\nif (pid == 0) { // 子进程：逻辑独立，物理页通常先通过写时复制共享\n    execve(program, argv, envp); // 成功后替换进程映像、PID 不变且不返回\n    report_exec_error(errno); _exit(127); // 只有失败才走到这里\n} else if (pid > 0) {\n    waitpid(pid, &status, 0); // 回收子进程并读取退出状态，避免僵尸\n} else { report_fork_error(errno); }", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("7.2 I/O 多路复用", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  select、poll、epoll 有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  select 每次需传入并扫描 fd 集合，且常受 FD_SETSIZE 限制；poll 去掉固定位图限制，但仍要遍历监视列表。epoll 在内核保存兴趣集和就绪列表，等待时主要取回就绪项，适合大量长连接。连接少或多数连接都活跃时差异未必明显，ET 模式还要求非阻塞并读写到 EAGAIN。 例如连接较少或大部分都活跃时，扫描成本可能不再是主要瓶颈。", size: 9.5pt)
  #raw("// select：每次重建 fd_set，并扫描受 FD_SETSIZE 限制的描述符。\nselect_wait_and_scan(all_fds);\n// poll：没有固定 fd_set 位图上限，但等待返回仍要遍历监视列表。\npoll_wait_and_scan(all_fds);\n// epoll：内核维护兴趣集与就绪队列，wait 主要取回有事件的 fd。\nauto ready = epoll_wait(epfd); for (auto event : ready) dispatch(event);\n// 连接少/多数都活跃时差别可能不明显；先按实测瓶颈选择。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  epoll 的 LT 与 ET 模式有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  LT 是电平触发：只要 socket 仍可读或可写，后续等待仍会报告，程序漏处理后通常还会再收到通知。ET 侧重状态从未就绪变为就绪的边沿，应用要使用非阻塞 I/O 并循环处理到 EAGAIN，否则缓冲区残留数据可能没有新边沿。ET 减少重复通知的机会，但处理逻辑更严格，不保证吞吐必然更高。 LT 适合先保证正确性，压测确认通知开销确实明显后再考虑 ET。", size: 9.5pt)
  #raw("// ET：注册前把 fd 设为非阻塞；就绪后循环读取直至 EAGAIN\nfor (;;) { auto n = ::read(fd, buffer, sizeof(buffer));\n    if (n > 0) { consume(buffer, n); continue; }\n    if (n == 0) { close(fd); break; } // EOF 后关闭并退出，不能继续读已关闭 fd\n    if (errno == EINTR) continue; // 信号中断但无数据，继续尝试\n    if (errno == EAGAIN || errno == EWOULDBLOCK) break; // 当前缓冲读空\n    handle_error(errno); break;\n} // ET 漏读到 EAGAIN 后不一定再有边沿；LT 通常会继续报告可读", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("7.3 内存、进程间通信与并发模型", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("007  什么是缺页异常？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  缺页异常发生在 CPU 访问虚拟地址而页表无法满足映射或权限要求时，它是处理器交给内核的同步异常。若是合法的按需分配、文件映射或换入页面，内核补齐页表后可重试原指令；越权或无效地址通常向进程报告 SIGSEGV/SIGBUS。少量缺页正常，持续主缺页和换页则可能说明内存压力或访问局部性差。 内存驻留缺页常无需磁盘 I/O，文件换入的主缺页则延迟可能更高。", size: 9.5pt)
  #raw("address = load_or_store(virtual_address);\nif (!page_table_has_mapping(address) || !permission_allows(address, operation)) {\n    trap_to_kernel_page_fault(address); // CPU 同步异常，交给内核判因\n    if (is_valid_demand_page(address)) { map_or_load_page(); retry_instruction(); }\n    else signal_process(SIGSEGV_or_SIGBUS); // 越权/无效地址不应盲目重试\n}\n// 匿名页分配、驻留页权限处理可无需磁盘；主缺页调入文件/交换页更慢。\n// 少量缺页常见，持续主缺页要排查内存压力与访问局部性。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("008  什么是虚拟内存？mmap 做了什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  虚拟内存让进程使用独立、连续的虚拟地址空间，页表再把页面映射到物理内存、交换区或文件，隔离和按需加载由此实现。mmap 建立文件或匿名映射，首次访问时可能才分配/调入页面；MAP_SHARED 可共享修改，MAP_PRIVATE 通常以写时复制隔离修改。映射不等于数据已读入 RAM，也需处理文件截断等边界。", size: 9.5pt)
  #raw("void* p = mmap(nullptr, length, PROT_READ | PROT_WRITE, MAP_SHARED, fd, offset);\nif (p == MAP_FAILED) return report_mapping_error(errno); // 先检查失败\n// offset 需满足页对齐等平台要求；返回映射不代表页已驻留 RAM\nwrite_bytes(p); // MAP_SHARED 与文件映射共享修改，落盘时机另行管理\nvoid* q = mmap(..., MAP_PRIVATE, ...); // 写入通常触发写时复制隔离\n// 文件截断后访问超出新 EOF 的页可能收到 SIGBUS\nmunmap(p, length); // 映射长度与释放范围要匹配", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("009  如何排查进程 CPU 使用率突然升高？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先用 top/ps 确认进程 CPU，再查看线程级占用，区分用户态和系统态；用 perf top/record 或采样 profiler 取得热点栈，映射线程 ID 时注意十进制与十六进制转换。结合请求量、日志和最近变更判断忙循环、锁争用、系统调用或算法退化。优化后在相同负载下比较吞吐和延迟，避免只看瞬时百分比。", size: 9.5pt)
  #raw("top_or_ps(pid); // 先确认进程 CPU，再找高占用线程并识别用户态/系统态\nfor (tid : hot_threads(pid)) { // ps -L / top -H 等工具得到线程 ID\n    profile_stack(tid); // perf top/record 或采样 profiler 找热点栈\n    map_tid_decimal_to_hex_for_logs(tid); // 日志/内核工具的 ID 进制可能不同\n}\ncorrelate_with_request_rate_logs_locks_syscalls_and_recent_changes();\noptimize_confirmed_hot_path();\nbenchmark_same_load_and_compare_throughput_and_tail_latency(); // 不凭瞬时 CPU 百分比下结论", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("010  如何用 GDB 定位崩溃？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先确保 core dump 已生成且二进制与调试符号对应，再执行 gdb ./程序 core 并查看 bt、线程列表及崩溃线程栈。围绕故障指令检查参数、对象生命周期和相邻内存，必要时切换线程并用 frame、print 查看变量。ASan/UBSan 或最小复现可帮助确认越界、空指针、释放后使用；栈顶位置往往只是症状，不一定是根因。", size: 9.5pt)
  #raw("enable_core_dump_and_reproduce();\ngdb(\"./program\", \"core\");\nthread_apply_all(\"bt\"); // 先看所有线程与崩溃线程栈，不把栈顶直接当根因\nselect_thread(crashing_thread); frame(fault_frame); print(arguments_and_nearby_state);\ncheck_binary_matches_core_and_debug_symbols(); // 符号不匹配会误导栈和变量\nrebuild_with_asan_ubsan_or_minimal_reproducer(); // 定位越界、空指针、释放后使用", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("011  常见的进程间通信方式有哪些？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  同机可用匿名/命名管道、消息队列、共享内存、信号量和信号；跨进程或跨主机也可用 Unix 域或 TCP/UDP socket。共享内存减少数据复制，需另配锁、原子量或进程间同步；管道和队列自带传递/排队语义但有容量限制。选型要看数据量、是否跨机器、背压与故障恢复要求。 例如同机大块数据选共享内存，小型父子进程流式通信可优先考虑管道。", size: 9.5pt)
  #raw("if (large_payload && same_host) { shared_memory(); add_process_shared_mutex_or_atomic(); }\nelse if (small_parent_child_stream) { pipe(); respect_pipe_capacity_and_backpressure(); }\nelse if (same_host && socket_protocol_needed) unix_domain_socket();\nelse { tcp_or_udp_socket(); } // 跨主机需要考虑网络故障与协议\n// 消息队列适合带排队语义的离散消息；信号只传少量通知信息。\n// IPC 选型同时看数据量、主机范围、同步/容量、背压和故障恢复。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("012  进程、线程和协程有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  进程有独立虚拟地址空间和资源边界，崩溃隔离较好但创建与切换开销通常较大；同进程线程共享堆和文件描述符，由内核调度，需要同步共享状态。协程由运行时在用户态按挂起点切换，适合大量等待 I/O 的任务，但阻塞调用可能卡住承载线程。协程能否并行取决于运行时是否把它们分派到多个内核线程。 例如大量网络等待适合轻量协程，独立隔离和不同故障域则更适合进程。", size: 9.5pt)
  #raw("Process p = isolated_address_space_and_resources(); // 故障隔离较好，创建/切换成本通常较高\nThread t = shared_heap_and_file_descriptors(p); // 内核调度；共享状态需加锁/原子保护\nCoroutine c = runtime_switches_at_await_points(); // 用户态轻量切换，适合大量 I/O 等待\nif (coroutine_calls_blocking_io()) block_carrier_thread(); // 可能连带卡住其他协程\nif (runtime_schedules_on_multiple_kernel_threads()) coroutine_work_can_run_in_parallel();\n// 选型按隔离、共享、调度成本与阻塞行为，不按“协程一定并行”判断。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("013  Linux 中 fork 后的 Copy-on-Write（写时复制）是怎样工作的？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  fork 后父子拥有逻辑独立的页表映射，但 Linux 通常先把只读映射指向同一物理页并标记为写时复制。任一方写页面时触发缺页，内核分配新页并复制内容，写入方改用副本；未被修改的页继续共享。这样 fork+exec 避免复制大量数据，但写入密集时仍会付出页复制和页表建立成本。 大量写入会把节省下来的初始复制成本转化为按页发生的复制，因此要按写入比例评估收益。〔S5〕", size: 9.5pt)
  #raw("fork(); // 父子逻辑上各自拥有地址空间，物理只读映射可暂时共享\nmark_shared_pages_read_only_and_cow();\nif (parent_or_child_writes(page)) {\n    page_fault(); // 写入方触发内核异常\n    private_copy = allocate_and_copy(page); remap_writer(private_copy);\n}\n// 未写页面继续共享；fork 后立即 exec 常省去大部分数据复制。\n// 若大量页被写，仍要复制页面并建立页表，成本按写入比例发生。", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("7.4 I/O 完成模型", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("014  Reactor 和 Proactor 两种 I/O 模式有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Reactor 通知“某 fd 现在可读/可写”，应用收到后自行调用非阻塞 read/write；Proactor 则先提交读写请求，完成后通知应用并提供结果。Linux epoll 本身是就绪通知，因此常用作 Reactor；异步库可以封装出完成回调式接口。比较时看应用实际收到的是就绪还是操作完成，不要仅凭 API 的回调形式判断内核模型。〔S5，S6〕", size: 9.5pt)
  #raw("// Reactor：就绪通知只说明“可以尝试”，应用仍执行非阻塞读写。\nfor (event : epoll_wait(epfd)) { if (event.readable) read_until_eagain(event.fd); }\n// Proactor：先提交 I/O 请求，完成时通知，回调拿到结果/字节数。\nsubmit_async_read(fd, buffer, on_completion_result);\n// 判断模式看通知表示 ready 还是 operation completed，而不是看 API 有无 callback。\n// Linux epoll 是就绪通知；异步库可在上层包装成完成回调式接口。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("015  epoll 和 io_uring 的 I/O 模型有什么不同？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  epoll 注册 fd 并等待就绪事件，收到可读通知后仍由应用调用 read；它报告的是“现在可能做得了”，并非读取结果。io_uring 通过共享提交队列提交读写等请求、从完成队列取操作结果，可减少逐次系统调用和数据复制。可用操作、内核支持和安全限制随版本与文件类型而异，部署要检查目标内核并按实际负载基准测试。〔S5〕", size: 9.5pt)
  #raw("epoll_add(fd, READABLE); // 内核记录兴趣；返回就绪后仍由应用调用 read\nif (epoll_wait_reports(fd)) n = ::read(fd, buffer, size);\nsubmit_io_uring_sqe(READ, fd, buffer, size); // 提交队列发布读写操作请求\ncqe = wait_io_uring_cqe(); // 完成队列带回操作结果，而不只是“可能可读”\n// io_uring 可减少逐次系统调用/复制，但受内核版本、文件类型和安全限制影响。\n// 先核对目标环境支持情况，再按真实负载基准测试。", lang: "cpp", block: true)
]

#heading(level: 1, outlined: true)[#text("第8章 计算机网络", size: 15pt, weight: "bold", fill: rgb("#000000"))]
#heading(level: 2, outlined: true)[#text("8.1 HTTP 与安全连接", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  HTTP GET 与 POST 有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  GET 的核心语义是请求目标资源的表示，通常应安全且幂等，因此适合查询；POST 请求目标资源按其语义处理所附内容，常用于创建或触发动作。把参数放 URL 是常见做法，不是判定方法或安全性的标准；URL 可能进入日志和历史记录。是否缓存取决于方法、响应头和缓存规则，POST 也不是天然不可缓存。 安全方法也应避免服务端把 GET 用作不可重复的资金扣减等写操作。", size: 9.5pt)
  #raw("request = HTTP_GET(resource_uri); // 获取表示；语义应安全且幂等，适合查询\nrequest = HTTP_POST(collection_uri, payload); // 按目标资源语义处理内容，常用于创建/动作\n// 不能仅凭“参数在 URL 还是 body”判定方法语义或安全性。\n// GET 写操作若扣款，重试/预取会造成副作用，设计本身就不安全。\nresponse_cache = cache_by_method_and_headers(request, response); // 按规则决定\n// URL 可能进入浏览器历史和日志；敏感数据需正确认证/授权与传输保护。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  HTTP/1.1 常见状态码如何分类？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  1xx 是临时信息响应，2xx 表示请求被成功接收、理解或处理，如 200、201、204；3xx 要求重定向或使用缓存结果。4xx 表示请求端问题，如 400、401、403、404、429，5xx 表示服务器处理失败或网关异常，如 500、502、503、504。重试要看状态语义，429/503 可结合 Retry-After，普通 4xx 通常不应盲目重试。", size: 9.5pt)
  #raw("switch (response.status) {\ncase 100: case 103: interim_information_only(); break; // 1xx 不是最终结果\ncase 200: success_with_representation(); break; case 201: resource_created(); break;\ncase 204: success_without_body(); break; // 2xx 成功类\ncase 301: follow_redirect_or_cache_by_rules(); break; // 3xx\ncase 401: authenticate_request(); break; case 403: deny_authorized_identity(); break;\ncase 404: resource_absent(); break; case 429: wait_retry_after_with_backoff(); break;\ncase 503: retry_if_safe_and_retry_after_allows(); break; // 5xx\n}\n// 4xx 通常先修正请求，不盲目重试；仍须考虑幂等性和截止时间", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  HTTP/HTTPS、TLS 和证书分别解决什么问题？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  HTTPS 是 HTTP 在 TLS 安全通道上的使用方式；TLS 握手协商算法与密钥并认证服务端，记录层保护后续数据机密性和完整性。证书含公钥及身份信息，由证书链连接到客户端信任的 CA，客户端还要检查域名、有效期和用途。握手常用非对称密码认证/协商，再用对称密钥高效保护数据；TLS 本身不保证应用权限正确。", size: 9.5pt)
  #raw("client = connect_tls(server_name);\ncert = peer_certificate_chain();\nverify_chain_to_trusted_CA(cert); verify_hostname(cert, server_name);\nverify_expiry_and_usage(cert); // 证书提供公钥/身份链，客户端仍须检查用途和域名\nkeys = tls_handshake_negotiate_and_authenticate(cert); // 非对称机制用于认证/协商\nsecure_channel = derive_symmetric_keys(keys); // 后续记录层保护机密性与完整性\nsend_http_over(secure_channel); // TLS 不替代应用自身的权限检查", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  TCP Keep-Alive 与应用层心跳有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  TCP Keep-Alive 是操作系统针对空闲 TCP 连接发送探测报文，按系统参数等待并重试，以发现已失联的对端；默认探测间隔可能很长，各平台可配置。应用心跳由协议主动发送，能检测应用进程卡死、会话过期或业务层失效，周期可按 SLA 设定。二者都只提供存活线索，调用仍须有截止时间、退避重试及幂等保护。", size: 9.5pt)
  #raw("tcp_keepalive_enable(socket); // 空闲探测由 OS 参数控制，默认间隔可能很长\nschedule_application_heartbeat(session, sla_period); // 检查进程卡死/会话失效\nif (heartbeat_deadline_missed()) mark_suspect_then_reconnect_with_backoff();\nset_request_deadline(deadline); // 连接探测成功不代表某次业务调用会完成\nretry_only_if_operation_is_idempotent_or_has_request_id();\n// 代理、线程阻塞和网络分区都可能影响探测；两者只是存活线索\n// 应按 SLA 配探测间隔/重试，而不是依赖操作系统默认 keepalive", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("8.2 TCP、UDP 与传输控制", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  TCP 三次握手和四次挥手如何进行？为什么需要 TIME_WAIT？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  客户端发送 SYN，服务端以 SYN+ACK 确认并提供自己的初始序号，客户端 ACK 后连接建立，双方确认双向通信并同步序号。关闭时两个发送方向可独立终止，所以常见 FIN、ACK、FIN、ACK 四段。主动关闭方进入 TIME_WAIT 一段时间，以便重传最后 ACK 并让旧连接报文从网络消退；它有助于端口复用安全，不是单纯浪费连接。", size: 9.5pt)
  #raw("client.send(SYN, seq=c); server.reply(SYN | ACK, ack=c+1, seq=s);\nclient.send(ACK, ack=s+1); // 确认双方初始序号与双向可达后建立连接\n// 关闭方向独立：FIN -> ACK -> FIN -> ACK，常见四段挥手\nactive_closer.send(FIN); peer.ack_then_later_send(FIN); active_closer.send(ACK);\nactive_closer.enter(TIME_WAIT); // 主动关闭方等待，必要时重传最后 ACK\nwait_2MSL_then_release_tuple(); // 让旧报文消退，避免新连接误收旧段\n// TIME_WAIT 占用有成本，但也保护端口复用和连接正确性", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  TCP 与 UDP 有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  TCP 提供连接内有序、可靠的字节流，并实现重传、流量控制与拥塞控制；应用必须自行定义消息帧。UDP 保留数据报边界，但协议不保证交付、顺序或去重，也没有内建拥塞控制。DNS 查询常用 UDP 并按需转 TCP，实时媒体可容忍部分丢包；选择应看时延、可靠性及应用层能否处理丢包。", size: 9.5pt)
  #raw("tcp.send(bytes); // TCP 不保留 send/recv 边界，提供有序可靠字节流\nreceive_with_length_prefix_delimiter_or_fixed_frame();\n// TCP 用 ACK/重传、流量控制和拥塞控制；可靠性会带来重传/队头等待。\nudp.send_datagram(bytes); // 保留数据报边界，但协议不承诺交付/顺序/去重\nif (dns_query || loss_tolerant_realtime_media) choose_udp_when_app_semantics_fit();\n// DNS 需要时也会转 TCP；UDP 应用需自行考虑丢包与拥塞，不能假设可靠。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("007  TCP 如何实现可靠传输？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  TCP 用序列号标记字节位置、ACK 确认已收到的数据，校验和检测传输损坏；缺失数据会由重传定时器或重复 ACK 触发重传。接收窗口限制发送方未被接收端接受的数据量，拥塞控制再根据网络状况调速。它交付有序字节流而非报文边界，所以一次 send 对应几次 recv 没有保证。 连接建立后的 MSS、接收缓存和网络路径变化也会影响可用吞吐。", size: 9.5pt)
  #raw("#include <algorithm>\nsegment.seq = first_byte_sequence; segment.checksum = checksum(header, payload);\nreceiver.accept_in_order_bytes(); receiver.send_cumulative_ack(next_expected_seq);\nif (timer_expired || duplicate_acks_indicate_gap) retransmit_missing_range();\nlimit_in_flight_by(std::min(receiver_window_rwnd, congestion_window_cwnd));\n// 序列号/累计 ACK 支持有序交付；校验和发现传输损坏\n// rwnd 保护接收缓存，cwnd 保护网络路径；二者较小者限制在途字节\n// TCP 向应用交付字节流，无消息边界；MSS、缓存和路径也影响吞吐", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("008  TCP 流量控制与拥塞控制有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  流量控制保护接收端：接收方通告窗口 rwnd，发送方不能超过接收缓冲区可容纳的数据。拥塞控制保护路径中的网络：发送方根据丢包、时延或 ECN 等信号调整拥塞窗口 cwnd。实际在途数据通常受 rwnd 与 cwnd 中较小者约束；前者慢可能是消费者读取不及时，后者小则可能是链路拥塞。 接收窗口降到零时，发送方会按协议探测窗口何时重新开放。", size: 9.5pt)
  #raw("#include <algorithm>\nrwnd = receiver_advertised_free_buffer(); // 接收端流控，保护消费/缓存能力\ncwnd = sender_congestion_controller_estimate(); // 网络拥塞控制，保护传输路径\nin_flight_limit = std::min(rwnd, cwnd);\nif (rwnd == 0) periodically_probe_window_update(); // 对端读出数据后可重新开放\nif (cwnd_is_small_or_loss_detected()) reduce_send_rate_and_recover();\n// rwnd 小先查应用读取/缓冲；cwnd 小查丢包、时延、ECN 等路径反馈\n// 窗口探测不是立即发送任意数据，发送方仍须遵守协议窗口规则", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("009  TCP 滑动窗口是什么？窗口会向左移动吗？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  发送窗口表示可发送但尚未确认的序列号区间，接收窗口反映接收端可接收空间，二者共同限制在途字节。ACK 确认推进左边界，窗口通告决定右边界，因此可见窗口宽度收缩或停滞；序列号环绕和旧数据重传需依 TCP 规则处理。调试时区分“窗口整体位置”与“窗口大小”，不能把窗口缩小误解为已发送数据可被撤销。 ACK 可能累计确认多个连续字节，窗口更新也可独立于新数据到达。", size: 9.5pt)
  #raw("send_window = [oldest_unacked_seq, right_edge_allowed_by_peer_and_cwnd);\nif (ack_covers_contiguous_bytes) move_left_edge_forward(ack.next_expected_seq);\nif (peer_updates_receive_window) recompute_right_edge(peer.rwnd);\n// ACK 可累计确认多个连续字节，窗口更新也可不伴随新数据。\nif (visible_width_shrinks) do_not_retract_already_sent_bytes();\n// 区分窗口位置和窗口宽度；序列号环绕/重传依 TCP 规则处理。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("010  什么是 MTU？IP 包超过路径 MTU 会怎样？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  MTU 是一段链路能承载的最大网络层包尺寸；路径 MTU 由端到端路径中最小的链路 MTU 限制。IPv4 在允许时可由路由器分片，设置 DF 后则需要 ICMP 错误协助发现；IPv6 路由器不分片，源端依据 ICMPv6 调整。TCP MSS 约束单段 TCP 负载，需扣除 IP/TCP 头部，路径配置异常会造成黑洞和重传。", size: 9.5pt)
  #raw("path_mtu = minimum_link_mtu_on_route(); // 端到端路径上的最小链路 MTU\nmss = path_mtu - ip_header_bytes - tcp_header_bytes; // TCP 负载要扣除头部\nif (ipv4 && fragmentation_allowed) router_may_fragment_packet();\nif (ipv4_df || ipv6) source_uses_icmp_feedback_to_adjust_packet_size();\n// IPv6 路由器不分片，需由源端依据 ICMPv6 做 PMTU 发现\nif (icmp_blocked_or_misconfigured()) detect_path_mtu_black_hole_and_retransmissions();\n// TCP MSS 影响分段负载；隧道封装等还会进一步减小可用 MTU", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("011  什么是 TCP 粘包/拆包？如何解决？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  TCP 只提供连续字节，不保留发送调用的分界；短时间内多次 send 可能被一次 recv 读到，单次 send 也可能分多次到达。协议应定义消息边界：固定长度、分隔符、长度前缀或自描述编码都可行。解析器要缓存半包、循环处理多帧，并限制声明长度、校验格式，防止恶意超长帧耗尽内存。 常见长度前缀帧还需限制最大帧大小，并支持一次缓冲中解析多帧。", size: 9.5pt)
  #raw("buffer.append(socket.read_available()); // TCP 是字节流，一次 send 不对应一次 recv\nwhile (buffer.size() >= header_bytes) {\n    length = decode_big_endian_length(buffer);\n    if (length > MAX_FRAME || length > SIZE_MAX - header_bytes) close_as_protocol_error();\n    if (buffer.size() < header_bytes + length) break; // 半包留待后续读取\n    parse_and_validate_frame(buffer.subspan(header_bytes, length));\n    buffer.erase_prefix(header_bytes + length); // 同一缓冲可能含多帧\n}\n// 定长、分隔符或长度前缀都能定界；校验格式并限制长度防内存耗尽\n// 解析循环只消费完整帧，不能把残留半帧误判为错误", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("8.3 名称解析与服务端网络", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("012  浏览器输入 URL 到页面显示大致经历什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  浏览器先解析 URL 和策略，可能命中缓存或 Service Worker；未命中时通过系统解析器获取地址，并建立 TCP/TLS 或 QUIC 连接。随后发送 HTTP 请求并接收响应，解析 HTML 构建 DOM、解析 CSS 构建样式信息，再计算布局、绘制合成，同时执行脚本并请求图片等子资源。DNS、连接和资源缓存、重定向、预加载都会改变顺序与等待时间。", size: 9.5pt)
  #raw("url = parse_and_normalize(input_url); if (service_worker_or_cache_hit(url)) render_cached();\nip = resolve_dns_via_browser_os_or_recursive_cache(url.host); // 未命中才向上查询\nconnection = connect_tcp_tls_or_quic(ip, url); response = send_http(connection, url);\ndom = parse_html(response); styles = parse_css_and_compute_style(dom);\nlayout(dom, styles); paint_and_composite();\n// 脚本可能在过程中执行并请求子资源；缓存、重定向和预加载会改变顺序。\n// DNS/连接/资源耗时分别影响等待，不是单一固定串行流水线。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("013  Linux listen(backlog) 参数控制什么？SYN 队列和 accept 队列有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Linux 上 listen(fd, backlog) 的 backlog 控制握手完成、等待 accept 的连接队列容量；尚未完成握手的 SYN 请求属于另一队列，受 tcp_max_syn_backlog 等机制影响。请求值会受系统 somaxconn 上限约束，队列满时客户端可能重试或失败。排查连接积压还要看应用 accept 速度、半连接压力和内核参数，其他操作系统语义可能不同。〔S5〕", size: 9.5pt)
  #raw("#include <algorithm>\nlisten(fd, requested_backlog); // Linux 主要限制已完成握手、等待 accept 的队列\nsyn_queue_capacity = tcp_max_syn_backlog; // 半连接请求属于另一队列/机制\nactual_accept_limit = std::min(requested_backlog, somaxconn);\nwhile (accept_queue_growing()) measure_application_accept_rate_and_worker_latency();\n// 队列满时客户端可能重试或失败；检查半连接压力、内核参数和 accept 速度\n// tcp_max_syn_backlog/somaxconn 的实际行为依 Linux 版本和配置验证\n// backlog 不能代替及时 accept、连接超时和容量规划", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("014  TCP 的 Nagle 算法和 Delayed ACK 分别做什么？为什么会增加请求响应延迟？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Nagle 算法减少小 TCP 段：已有未确认数据时，新的小写入通常先暂存，等 ACK 或攒到足够数据再发。Delayed ACK 则让接收端短暂等待，尝试合并 ACK 或与反向数据一起确认；两者组合可能让小请求和小响应多等一个确认周期。交互协议可测试 TCP_NODELAY，但批量发送、拥塞和包开销也应一起衡量。〔S7〕", size: 9.5pt)
  #raw("write_small_request(); // 有未确认数据时，Nagle 可能暂存后续小段\nreceiver_may_delay_ack_briefly(); // 接收端尝试合并 ACK 或搭载反向数据\n// 两者叠加时，小请求/响应可能多等一个确认周期\nif (interactive_latency_is_measured_bottleneck) setsockopt(TCP_NODELAY, true);\n// 关闭 Nagle 可降低等待，但会增加小包数量和网络开销\n// Delayed ACK 时机依实现/流量；测量真实 RTT 和请求大小再调整\n// 批量吞吐、拥塞和服务器负载也应一起比较", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("015  HTTP/2 和 HTTP/3 在传输层和多路复用上有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  HTTP/2 将多个请求流复用到一条 TCP 连接并使用 HPACK 压缩头部，但 TCP 丢包时，后续字节即使属于其他流也要等待重传数据。HTTP/3 将 HTTP 帧映射到 QUIC 流，QUIC 在 UDP 上实现加密、可靠传输和按流复用；一个流丢包通常不阻塞其他流的数据交付。共享拥塞控制、连接层丢包仍会影响整体吞吐，因此不是消除所有队头阻塞。〔S7〕", size: 9.5pt)
  #raw("http2.multiplex_streams_over_one_tcp_connection(); http2.compress_headers_with_HPACK();\nif (tcp_segment_lost) later_tcp_bytes_wait_for_retransmission(); // 跨流字节队头阻塞\nhttp3.map_http_frames_to_quic_streams_over_udp();\nif (quic_stream_A_lost) stream_B_can_deliver_independent_bytes();\n// QUIC 仍有共享拥塞控制和连接层丢包影响，不是消除所有阻塞。\n// HTTP/3 通常还整合 TLS 加密；性能依网络与实现。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("016  一次典型 DNS 解析会经过哪些角色？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  客户端通常先查浏览器、系统或本地缓存，再向配置的递归解析器发起查询；缓存命中即可返回。未命中时递归解析器沿 DNS 委派关系查询根、顶级域及权威服务器，可能从缓存或转发器获得答案，并按 TTL 缓存。DoH/DoT 改变客户端到解析器的传输方式，但不会改变权威数据层级；实际请求未必逐级访问所有服务器。〔S8〕", size: 9.5pt)
  #raw("if (browser_cache.contains(name)) return browser_cache[name];\nif (os_or_recursive_resolver_cache.contains(name)) return cached_answer;\nanswer = recursive_resolver.query_root_then_tld_then_authoritative(name);\nrecursive_resolver.cache(answer, answer.ttl); // 未命中才按委派关系逐层查询\n// 实际递归器可能命中转发器/缓存，不一定访问每一级权威服务器。\n// DoH/DoT 改变客户端到解析器的传输保护，不改变 DNS 权威层级。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("017  SO_REUSEADDR 和 SO_REUSEPORT 有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  在 Linux 上，SO_REUSEADDR 主要影响地址复用和重启后绑定等场景，不能简单视作多个进程共同监听同一端口的开关。SO_REUSEPORT 允许满足条件的多个 socket 在 bind 前启用该选项并绑定相同地址端口，内核可把连接分散给监听者；权限及地址匹配有具体规则。Windows、BSD 与 Linux 的行为存在差别，依赖该选项时应查目标平台文档并实测。〔S5〕", size: 9.5pt)
  #raw("set_option(SO_REUSEADDR); // Linux 常用于重启绑定等规则，不代表任意多进程共享监听\nif (multiple_listeners && each_socket_sets_before_bind(SO_REUSEPORT)) {\n    bind_same_eligible_address_and_port(); kernel_distributes_connections();\n}\n// 需满足权限、地址匹配等条件；不同 Linux/BSD/Windows 语义有差异。\nverify_target_os_docs_and_test(); // 不把同名选项当跨平台等价保证", lang: "cpp", block: true)
]

#heading(level: 1, outlined: true)[#text("第9章 数据库与缓存", size: 15pt, weight: "bold", fill: rgb("#000000"))]
#heading(level: 2, outlined: true)[#text("9.1 Redis 与缓存设计", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  MVCC 是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  MVCC 为同一行保留带事务可见性信息的多个版本，读事务按快照选择自己可见的版本，从而让普通读尽量不阻塞写。写操作仍要取得锁或检测冲突，因此 MVCC 不等于“没有锁”。长事务会拖住旧版本清理、扩大 undo/history，因此应控制事务时长并观察历史版本积压。 例如一致性读可看到事务开始时的快照，而当前读通常还要加锁协调。", size: 9.5pt)
  #raw("T1.begin(); snapshot = T1.capture_visible_versions();\nT2.update(row); T2.commit();\nT1.read_consistent(row, snapshot); // 按可见性信息沿版本链选快照版本\nT1.current_read_for_update(row); // 当前读可能加锁，写仍需冲突检测/锁\nT1.commit(); vacuum_or_purge_old_versions_when_no_reader_needs_them();\n// 长事务拖住 undo/history 清理；MVCC 减少普通读写冲突，不等于没有锁。", lang: "sql", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  Redis RDB 与 AOF 持久化有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  RDB 在某个时点生成紧凑快照，通常启动恢复快、适合备份，但故障时可能丢失上次快照后的写入。AOF 记录可重放的写命令，数据恢复点可更近，代价是文件和重放时间可能较大；每秒 fsync 与每次 fsync 的耐久性和延迟不同。两者可并用，先按可接受丢失窗口和恢复时间目标测试配置。 RDB 后台快照会利用 fork 和写时复制，写密集时仍可能增加内存占用。", size: 9.5pt)
  #raw("periodically_fork_snapshot_to_RDB(); // 紧凑，恢复通常快；只含某时点，可能丢其后写入\nappend_write_commands_to_AOF(); // 恢复点可近，需重放且文件可能更大\nconfigure_fsync(\"everysec\"); // 延迟/耐久折中；always 更耐久也可能更慢\nif (background_snapshot_writes) account_for_COW_memory_amplification();\n// 监控快照年龄、AOF 重写、恢复耗时；按 RPO/RTO 实测，而非只看格式。\nenable_both_if_backup_restore_speed_and_a_finer_RPO_are_both_required(); // 同时运行仍要监控资源", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  Redis 内存满时如何处理？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  达到 maxmemory 时 Redis 按配置的策略淘汰键；noeviction 会对需要额外内存的写操作返回错误，读仍可能正常。volatile 策略只从设过过期时间的键中选择，若没有此类键也可能无法淘汰；allkeys 策略可从所有键选。预留复制、AOF 缓冲和碎片等内存，并监控淘汰次数、命令错误与延迟。", size: 9.5pt)
  #raw("if (used_memory_reaches_maxmemory) {\n    if (policy == noeviction) return write_error_but_reads_may_work();\n    candidates = policy_is_volatile ? keys_with_ttl : all_keys;\n    if (candidates.empty()) return eviction_cannot_free_key();\n    evict_by_configured_policy(candidates); // LRU/LFU/TTL 等按配置近似选择\n}\nreserve_memory_for_replication_AOF_buffers_and_fragmentation();\nmonitor(evicted_keys, rejected_writes, latency);", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  Redis 分布式锁需要注意什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  获取锁可用 SET key 唯一令牌 NX PX ttl 原子完成，释放时用 Lua 仅在令牌仍匹配时删除，防止过期后误删他人锁。任务执行时间可能超过租约，续租也会遇到暂停或网络分区，因此锁过期后旧持有者仍可能继续写。若资源要求严格互斥，应让下游检查单调递增的 fencing token 或用数据库条件更新兜底。", size: 9.5pt)
  #raw("token = cryptographically_random_unique_owner_token();\nif (SET(lock_key, token, NX, PX=lease_ms) != OK) return LockBusy;\nfencing = allocate_monotonically_increasing_fencing_token(); // 每次获取严格递增\n// 业务执行可能超过租期；长暂停/分区后旧持有者仍可能继续运行\nresource.write_if_fencing_token_is_newer(fencing, update); // 下游拒绝旧 token\nrelease_with_lua_if_get_equals_token_then_del(); // 避免误删后来 owner 的锁\n// token 比对只保护锁删除；严格互斥还需受保护资源校验 fencing/DB 条件更新\n// 锁租约、续租超时和业务截止时间需一致设计", lang: "text", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  Redis 常见数据结构及适用场景是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  String 可存简单值、计数器和缓存；Hash 适合对象字段，List 可做两端队列，Set 做去重，ZSet 支持按分数排序和取 Top N。Stream 提供带 ID 的追加消息流及消费组，Bitmap、HyperLogLog、GEO 分别支持位状态、近似基数和地理查询。选择结构时要看命令复杂度、集合大小、持久化及数据是否需要精确。", size: 9.5pt)
  #raw("SET(key, value); INCR(counter); // String：缓存值/计数\nHSET(user, field, value); // Hash：字段对象；List 可做两端队列\nSADD(tags, tag); // Set 去重；ZADD(rank, score, member); // ZSet 排序/Top N\nXADD(stream, id, fields); // Stream 带 ID 消息流/消费组\nSETBIT(flags, offset, 1); HLL_ADD(unique_visitors, item); GEOADD(locations, lon, lat, id);\n// Bitmap / HyperLogLog / GEO 分别用于位状态、近似基数、地理查询。\n// 比较命令复杂度、集合规模、精确性、持久化与恢复需求再选。", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("9.2 MySQL 索引、事务与并发控制", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  为什么 MySQL InnoDB 索引常用 B+ 树？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  B+ 树内部节点只保存分隔键和子指针，扇出高，树高通常较低；叶子按键有序，范围扫描能顺序访问相邻页。InnoDB 聚簇索引叶子存整行，二级索引叶子保存主键值，因此二级索引回表可能增加随机访问。相比哈希索引，B+ 树还能支持排序、前缀和范围查询，代价是维护索引会增加写入与存储开销。 InnoDB 页内存放有序键和记录引用，分裂页也会带来写放大。", size: 9.5pt)
  #raw("page = read_index_page(); // InnoDB 页内按序保存键和记录引用\nwhile (!leaf_page(page)) page = page.child_for(key); // 高扇出，降低树高/随机 I/O\nrecord = page.find_in_leaf(key); // 叶子有序，范围查询可顺序扫描相邻叶\n// 聚簇索引叶子包含整行；二级索引叶子保存主键，必要时回表。\ninsert_new_key_may_split_page_and_write_more_pages(); // 写入/空间开销\n// 哈希查找不天然支持排序/范围；B+ 树维护成本换范围能力。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("007  什么情况下索引可能无法有效使用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  函数包裹索引列、隐式类型转换、复合索引跳过左侧列、前缀通配符等可能让条件无法按预期做索引查找；低选择性时优化器也可能判断全表扫描更便宜。统计信息过期或返回大量列会改变计划。先看 EXPLAIN 的访问类型、估计行数和实际执行情况，再用代表性数据验证改写，不能机械地要求每个查询都走索引。 复合索引中等值列和范围列的排列会决定后续列还能否用于定位。", size: 9.5pt)
  #raw("EXPLAIN ANALYZE SELECT ... WHERE indexed_column = ?; // 看真实行数/耗时\n// 函数包列、隐式类型转换、跳过复合索引左前缀、LIKE '%x' 可能妨碍查找。\n// 等值列通常放在范围列前；范围列之后的索引列定位能力有限。\nif (predicate_has_low_selectivity || returns_many_rows) optimizer_may_scan_table();\nrefresh_statistics_if_stale(); rewrite_predicate_without_changing_semantics();\n// 用代表性数据验证新计划；全表扫描有时确实更便宜。", lang: "sql", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("008  如何分析并优化一条慢 SQL？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先从慢查询日志定位高频或高耗时语句，用 EXPLAIN/ANALYZE 看估算与实际行数、连接顺序、回表和排序临时表。检查过滤条件、联合索引顺序、返回列、分页方式及 N+1 调用，减少扫描和往返。改动后用真实数据分布压测读写两侧，并检查锁等待、索引维护成本和执行计划回归。 EXPLAIN 的估算值不一定代表实际成本，热点参数和冷数据都应纳入基准。", size: 9.5pt)
  #raw("plan = EXPLAIN_ANALYZE(query); // 先区分估算与实际扫描行数、索引、排序和回表\nprofile_slow_stages(); check_lock_waits_and_io();\nrewrite_query_or_add_composite_covering_index_if_measurements_justify();\nrun_on_representative_data(); compare_rows_latency_and_write_cost();\n// 避免只靠 EXPLAIN 估算或盲目添加索引；索引会增加存储和写放大。\n// 检查参数分布、统计信息、返回列与 LIMIT 是否改变计划。", lang: "sql", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("009  如何防止 SQL 注入？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  预编译或参数化查询把用户值作为数据绑定，避免输入被解析成 SQL 语法；例如 `WHERE id = ?` 不把字符串拼进 SQL。表名、列名等通常不能作为普通参数绑定，应通过固定白名单映射选择。输入校验与最小数据库权限是纵深防御，转义字符串不能替代参数化。 参数绑定也能避免不同输入导致语句结构变化，便于数据库复用执行计划。", size: 9.5pt)
  #raw("query = db.prepare(\"SELECT id FROM users WHERE name = ?\");\nquery.bind(0, user_input); // 把用户值作为数据绑定，不拼进 SQL 语法\nquery.execute(); // 数据库按参数类型处理，语句结构保持固定\n// 表名/列名/排序方向通常不能用值占位符绑定\ncolumn = whitelist_map[user_selected_sort]; // 用固定映射选择标识符\nexecute(\"SELECT id FROM users ORDER BY \" + column); // 仅拼接可信白名单项\n// 参数化不替代权限校验、最小数据库权限和错误处理", lang: "sql", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("010  数据库事务的 ACID 是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  原子性保证事务作为整体提交或回滚；一致性表示提交前后都满足业务约束；隔离性规定并发事务互相可见的效果；持久性保证提交后能经受规定范围内的故障恢复。数据库通过 undo/redo、锁或 MVCC、日志刷盘等机制提供这些性质。实际持久性受刷盘参数、复制确认和存储设备保证影响，ACID 不会自动修复业务规则错误。", size: 9.5pt)
  #raw("BEGIN TRANSACTION;\n// Atomicity：全部提交或回滚；Consistency：约束/业务不变量保持\nUPDATE account SET balance = balance - amount WHERE id = from_id;\nUPDATE account SET balance = balance + amount WHERE id = to_id;\n// Isolation：并发事务按隔离级别协调可见性；Durability：提交后依刷盘策略持久\nif (any_update_failed) ROLLBACK(); else COMMIT();\n// ACID 不替业务定义正确性；检查余额/行数并理解持久化配置。", lang: "sql", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("011  数据库读写分离有哪些一致性风险？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  主库提交后从库可能尚未应用日志，因此立刻读从库会看不到刚写的数据；故障切换也可能丢掉未复制或未确认的提交。可对写后读粘主库、等待复制位点追平，或给客户端明确最终一致读取语义。还需定义超时重试的幂等性及切主时读写路由，不能把“复制正常”当作零延迟保证。 需要强读后写语义时，可在应用会话内暂时固定读主库并设置最长等待时间。", size: 9.5pt)
  #raw("primary.commit(write); replica.apply_async(write); // 复制存在延迟\nread_from_replica(); // 可能读到旧值，读己之写不一定成立\nif (must_read_own_write) read_from_primary_or_wait_until_replica_lsn >= commit_lsn;\nif (failover_occurs) verify_acknowledged_write_was_replicated();\n// 还需处理复制中断、切换和读一致性目标；异步复制可能丢最近确认写。\n// 按业务在延迟、可用性、读写扩展间取舍。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("012  数据库隔离级别与常见并发异常是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  标准隔离级别从读未提交、读已提交、可重复读到可串行化，对并发异常的限制逐步加强，但实现方式和代价因数据库而异。脏读是读到未提交数据，不可重复读是同一行再次读取变值，幻读是同一范围再次查询出现新行。MySQL InnoDB 的 MVCC 与间隙/next-key 锁会影响具体表现，回答时应说明数据库、语句类型和隔离级别。", size: 9.5pt)
  #raw("T1.begin(isolation_level);\nvalue = T1.read(row); T2.update_and_commit(row);\n// Read Uncommitted 可见脏读；Read Committed 每条语句新快照，可能不可重复读。\n// Repeatable Read 通常保持事务快照；Serializable 会更严格地冲突/串行化。\nT1.read_again(row); // 幻读、不可重复读依数据库实现/当前读和范围锁而异\n// 用真实事务并发复现并检查锁/执行计划，不把隔离级别标签当实现细节。", lang: "sql", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("013  缓存穿透、击穿、雪崩分别是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  穿透是大量请求查询本不存在的数据，可在入口校验、缓存短 TTL 空值或用 Bloom Filter 过滤；过滤器有假阳性，不能据此断言一定存在。击穿指单个热点键失效后并发回源，可互斥重建或逻辑过期并限制并发。雪崩是大量键同时失效或缓存集群故障，应错开 TTL、限流、降级并保护数据库。 重建热点值时要限制并发数，避免互斥粒度过大导致请求集中排队。", size: 9.5pt)
  #raw("value = cache.get(key);\nif (value == MISS) { // 穿透：键不存在；负缓存可短暂记住空结果\n    if (bloom.definitely_absent(key)) return NotFound; // Bloom 有假阳性，不会证明存在\n    if (try_singleflight_lock(key)) rebuild_from_database_with_ttl_jitter();\n    else serve_stale_or_wait_with_deadline(); // 单热点失效时避免并发回源\n}\nif (many_keys_expire_together || cache_cluster_down) rate_limit_and_degrade();\n// 雪崩用 TTL 抖动/限流保护 DB；重建锁粒度要小并限制等待\n// 对 Bloom 命中仍要查真实存储，过滤器不能代替数据源", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("014  InnoDB 的 undo log、redo log 和 MySQL binlog 分别有什么作用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  undo log 保存回滚所需的旧值信息，也供一致性读沿版本链构造快照；redo log 记录 InnoDB 页变更相关信息，用于崩溃恢复；binlog 是 MySQL Server 层的逻辑变更日志，用于复制和时间点恢复。三者服务的层次、格式和生命周期不同，不能互相替代。长事务可能延迟 undo 清理，redo/binlog 的持久保证还取决于刷盘配置。〔S9〕", size: 9.5pt)
  #raw("old_value = undo_log.append_for_rollback_and_snapshot_visibility();\nredo_log.append_page_change_for_crash_recovery();\nbinlog.append_logical_server_change_for_replication_and_point_in_time_restore();\n// undo 服务回滚/MVCC 版本链；redo 服务 InnoDB 崩溃恢复；binlog 属 Server 层。\n// 日志格式、生命周期和持久化配置不同，不能相互替代。\nif (long_transaction) monitor_undo_history_cleanup_lag();", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("015  MySQL 为什么要协调 InnoDB redo log 和 binlog 的两阶段提交？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  一个提交要让 InnoDB 的引擎日志状态与 Server 层 binlog 一致，否则恢复和复制可能看到不同事务集合。MySQL 使用内部两阶段提交：引擎先准备，服务器写入并按配置持久化 binlog，再通知引擎提交；崩溃恢复据 prepare 状态与 binlog 记录协调完成提交或回滚。刷盘策略决定掉电时的耐久窗口，逻辑协调本身不等于硬件已持久化。〔S9〕", size: 9.5pt)
  #raw("engine.prepare(txn); // 引擎先 prepare，崩溃后可被协调\nserver.write_binlog(txn); flush_binlog_according_to_sync_policy();\nengine.commit(txn); // Server 确认日志后通知引擎提交\n// 崩溃恢复查看 prepare 状态与 binlog 记录，协调提交或回滚\n// 保持 InnoDB redo 与 Server binlog 的事务集合一致，服务恢复/复制\n// 刷盘频率影响掉电耐久窗口；两阶段协调不等于硬件已经持久化\n// 长事务/日志积压也会影响恢复与复制延迟", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("016  InnoDB 的 gap lock 和 next-key lock 是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Record lock 锁定索引记录；gap lock 锁住索引记录之间的间隙，阻止其他事务向该范围插入；next-key lock 是记录锁加其前方间隙锁。InnoDB 在某些隔离级别的范围锁定读中用 next-key 锁抑制幻读，但实际范围受扫描索引和查询条件影响。完整唯一键等值查找通常只需记录锁，调试应结合执行计划与锁等待信息。〔S9〕", size: 9.5pt)
  #raw("SELECT * FROM records WHERE key BETWEEN low AND high FOR UPDATE;\n// Record lock 锁住索引记录；gap lock 锁住记录间隙、阻止范围插入\n// Next-key lock = 记录锁 + 其前方间隙锁，可在部分范围读防幻行\nINSERT INTO records(key) VALUES (inside_locked_gap); // 可能等待/冲突\n// 完整唯一键等值查询常只需记录锁，范围扫描会涉及更多索引项\n// 实际锁取决于隔离级别、索引/执行计划和查询谓词，查看锁等待验证", lang: "sql", block: true)
]

#heading(level: 2, outlined: true)[#text("9.3 热点与大键治理", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("017  Redis 热 Key 和大 Key 有什么区别？如何排查？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  热 Key 的核心问题是请求集中，可能让单分片 CPU、网络或串行命令成为瓶颈；大 Key 则是单键拥有大量元素或大负载，整键读取、删除和复制可能耗时并放大内存峰值。可用访问采样/监控定位热键，按只读场景评估本地缓存或副本分流；大集合应拆分并分页操作。拆分会增加聚合与一致性复杂度，先确认键访问模式再调整。〔S10〕", size: 9.5pt)
  #raw("sample_key_access_frequency_and_per_shard_cpu_network(); // 热 Key：请求集中\nmeasure_key_bytes_element_count_and_whole_key_operation_latency(); // 大 Key：单键操作重\nif (hot_and_read_only) add_bounded_local_cache_or_read_replicas();\nif (large_collection) split_by_bucket_and_page_operations();\n// 大 Key 的整键读/删/复制可能阻塞分片并放大内存峰值\n// 热 Key 拆读流量要考虑一致性；大 Key 拆分增加聚合和更新复杂度\n// 调整后继续监控分片 CPU、网络、延迟和内存峰值", lang: "cpp", block: true)
]

#heading(level: 1, outlined: true)[#text("第10章 系统设计与分布式", size: 15pt, weight: "bold", fill: rgb("#000000"))]
#heading(level: 2, outlined: true)[#text("10.1 分布式基础与数据结构", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  CAP 理论如何用于分布式系统选型？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  CAP 讨论发生网络分区时的一致性与可用性：分区两侧无法可靠通信时，系统不能同时保证线性一致读写和所有请求都成功返回。CP 方案可能拒绝少数派写入，AP 方案可继续响应但允许暂时不一致；这是故障期间的选择，不是正常网络下永远只能二选一。先定义可用性、一致性语义和分区场景，再决定数据操作的策略。 AP 侧仍可按业务收敛数据，CP 侧也能在分区恢复后重新提供服务。", size: 9.5pt)
  #raw("if (network_partition) {\n    if (require_linearizable_reads_and_writes) reject_or_wait_on_minority(); // CP\n    else if (require_every_partition_to_respond) accept_writes_and_reconcile_later(); // AP\n}\n// CAP 约束故障分区期间的保证，不意味着正常网络下永远只能选 C 或 A。\ndefine_consistency_semantics_availability_slo_and_partition_cases_first();\n// AP 需要冲突解决/收敛；CP 多数派恢复后可继续服务。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  什么是 Bloom Filter？如何选择参数？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Bloom Filter 用 m 位数组和 k 个哈希标记集合元素；查询时只要有一位为 0 就能确定不存在，全为 1 则只是可能存在。标准结构在正确使用下无假阴性但有假阳性，也不支持直接删除。预估 n 个元素和误判率 p 后可用 m≈-n ln(p)/(ln2)^2 求位数、k≈(m/n)ln2 求哈希数，并为超容量留余量。 当实测误判率偏高时，可扩容过滤器或做分层过滤，而不是把命中当真。", size: 9.5pt)
  #raw("#include <cmath>\n#include <cstddef>\n#include <cstdint>\n#include <vector>\n// n > 0，0 < p < 1；容量超预估会提高误判率\nstd::size_t m = static_cast<std::size_t>(std::ceil(-n * std::log(p) / std::pow(std::log(2.0), 2)));\nstd::size_t k = static_cast<std::size_t>(std::round((static_cast<double>(m) / n) * std::log(2.0)));\nif (k == 0) k = 1; // 至少使用一个哈希位置\nstd::vector<std::uint8_t> bits((m + 7) / 8, 0);\nfor (auto h : k_hashes(key)) set_bit(bits, h % m); // 插入只置位\nfor (auto h : k_hashes(query)) if (!test_bit(bits, h % m)) return DefinitelyAbsent;\nreturn MaybePresent; // 无假阴性、有假阳性；命中仍查真实存储\n// 标准结构不能单键删除；监测误判率后扩容/分层", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  什么是一致性哈希？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  一致性哈希将键和节点映射到环上，键顺时针归属后继节点；增删节点主要影响相邻区间，减少全量搬迁。每个物理节点设置多个虚拟节点可平衡区间大小，但节点异构时应按权重分配。它只解决映射与部分迁移，热点键、故障复制和数据再均衡仍需单独设计。 虚拟节点数和权重会影响负载方差，迁移时还需做限速与双读切换。 重新映射后应渐进搬数据，并在迁移窗口设置读写转发或版本校验。", size: 9.5pt)
  #raw("for (Node node : nodes) for (int v = 0; v < virtual_nodes(node); ++v)\n    ring[hash(node.id, v)] = node; // 虚拟节点帮助均衡区间，也可按容量加权\nauto it = ring.lower_bound(hash(key)); if (it == ring.end()) it = ring.begin();\nowner = it->second; // 键映射到顺时针后继，增删节点主要移动相邻区间\n// 变更节点后限速迁移，可双读/转发并校验版本后切流\n// 一致性哈希不解决热点、复制和故障恢复；虚拟节点数需按负载调优\n// 监控分片负载方差，不能只凭“节点均匀”假设均衡", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  分布式 ID 生成器要满足什么要求？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  分布式 ID 通常要求唯一、可用、吞吐足够，并按业务决定是否要大致有序、紧凑或不可预测。数据库号段简单但需管理分配服务和缓存段；Snowflake 类 ID 把时间、节点号和序列组合，必须确保节点号不冲突并处理时钟回拨和单毫秒序列耗尽。UUID 易生成且分布式方便，但较长、按时间排序能力有限。 若要求严格全局单调，跨节点时钟与协调会明显降低生成可用性。", size: 9.5pt)
  #raw("id = database_allocated_range(); // 简单；需分配服务、缓存段和故障恢复\nid = UUID_random(); // 易分布式生成但较长，通常不按生成时间顺序聚集\nid = (timestamp_ms << (node_bits + seq_bits)) | (node_id << seq_bits) | sequence;\nif (node_id_conflicts) reject_configuration();\nif (clock_moves_backwards || sequence_exhausted) wait_or_reject_or_use_new_epoch();\n// 明确唯一/大致有序/紧凑/不可预测等要求；严格全局单调需协调，降低可用性。", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("10.2 数据处理与在线服务设计", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  如何从超大文件中找 Top K？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  数据可装入内存时用大小 K 的最小堆：前 K 个先入堆，之后只替换堆顶更小的候选，时间 O(N log K)、空间 O(K)。超大文件可按稳定哈希分桶，保证相同键落在同桶，再逐桶求候选并归并；若 Top K 是频率统计，还要先明确是否需全局聚合。近似算法可省内存，但应给出误差和置信边界。 局部各取 K 个候选再做堆归并可得到全局 K 个，但需保证分桶可完备划分。", size: 9.5pt)
  #raw("std::priority_queue<int, std::vector<int>, std::greater<int>> top_k; // 最小堆\nfor (value : stream) { if (top_k.size() < K) top_k.push(value);\n    else if (value > top_k.top()) { top_k.pop(); top_k.push(value); } }\n// 内存可容纳时 O(N log K)、O(K)；堆顶是候选里最小项。\n// 超大文件先稳定哈希分桶相同 key，再逐桶统计/取候选并归并。\n// 频率 Top K 要定义跨桶全局计数；近似算法应给误差/置信度。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  如何处理分布式事务？TCC 与 Saga 有何区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  TCC 把一次业务拆为 Try 预留、Confirm 确认和 Cancel 释放，能显式控制资源但要求各阶段幂等，并处理空回滚、悬挂和超时重试。Saga 将多个本地事务串成流程，失败时执行补偿动作；补偿是业务语义，不一定能精确还原，且中间结果可能被其他事务看到。能避免跨服务强事务时优先本地事务加 Outbox，按隔离和补偿要求选择。", size: 9.5pt)
  #raw("// TCC：Try 预留；各阶段按 transaction_id 幂等，并记录事务状态\nif (!inventory.try_reserve(txn_id)) return Failed;\nif (payment.try_charge(txn_id)) inventory.confirm(txn_id);\nelse { inventory.cancel_if_reserved(txn_id); payment.cancel_if_charged(txn_id); }\n// 空回滚：Try 未发生也可能收到 Cancel；悬挂：迟到 Try 不能复活已取消事务\n// Saga 则串本地事务，失败执行逆序业务补偿；补偿不保证精确还原\n// 能避免跨服务强事务时，用本地事务 + Outbox 降低协调复杂度", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("007  如何实现业务幂等？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  为每个逻辑请求生成唯一业务键，并在数据库唯一约束或原子条件更新下记录处理状态和结果；同键重试时返回已保存结果或正在处理状态。仅先查询再写入有并发竞态，两请求可能同时通过检查。还需规定幂等键作用域、过期时间、失败重试和同键不同参数的冲突行为。 状态记录最好含处理中、成功、失败及结果摘要，避免客户端重试产生新副作用。", size: 9.5pt)
  #raw("BEGIN;\nINSERT INTO request_dedup(request_id, status, parameter_hash)\nVALUES (?, 'processing', ?); // 唯一键原子抢占，避免“先查再写”竞态\n-- duplicate key 时读取已保存状态/结果，不重复执行副作用。\nUPDATE orders SET status = 'created' WHERE id = ?;\nUPDATE request_dedup SET status = 'done', result = ? WHERE request_id = ?;\nCOMMIT;\n-- 同 key 不同参数应拒绝；处理中超时需恢复/重试，键作用域与 TTL 要明确", lang: "sql", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("008  如何检索 TB 级日志中的关键词？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先把 TB 级日志按时间、服务、租户或分区缩小扫描范围，并通过并行分片扫描或索引检索关键词；频繁全文查询适合建立倒排索引。压缩和列式存储可降低 I/O，但解压、索引维护也耗资源。为防查询拖垮集群，应限制时间范围、并发、返回量和敏感字段访问。 若关键词模式稳定，倒排索引能把逐字节扫描转为候选文档定位。", size: 9.5pt)
  #raw("partitions = narrow_by_time_service_tenant_and_region(query);\nif (frequent_full_text_search) candidates = inverted_index.lookup(keyword);\nelse candidates = parallel_scan_compressed_partitions(partitions, keyword);\n// 列式/压缩可减少 I/O，但有解压和索引维护成本。\napply_time_range_concurrency_result_limit_and_field_acl();\n// 防止无范围查询拖垮集群；对敏感字段做访问控制和审计。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("009  如何用 Bloom Filter 判断海量键是否可能存在？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  对每个键做多个哈希并置位，查询时若任何位为 0 就可以判定不存在；位全为 1 时只能说可能存在，因为其他键可能置过这些位。插入量和目标误判率决定位数组大小与哈希个数，超出容量后误判率增加。标准 Bloom Filter 不支持删除，需删除时可考虑计数变体并权衡额外内存。 Bloom Filter 适合在访问昂贵存储前做快速负向过滤，正向命中仍要查真实数据。", size: 9.5pt)
  #raw("for (key : indexed_keys) bloom.insert(hash_positions(key));\nif (!bloom.maybe_contains(query)) return NotFound; // 任意一位为 0 可确定不存在\nrecord = primary_storage.lookup(query); // 位全为 1 也只是可能存在\nif (measured_false_positive_rate > target) resize_or_layer_filter();\n// 正确构造下标准 Bloom 无假阴性，但有假阳性，命中仍查真实数据\n// 标准 Bloom 不支持删除；Counting Bloom 支持删除但内存更高\n// n 和目标误判率 p 决定 m/k；超容量后需扩容或分层", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("010  如何设计 O(1) 的 LRU 缓存？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  哈希表保存 key 到双向链表节点的映射，链表头代表最近使用、尾部代表最久未用；命中时摘下节点移到头部，淘汰时删尾节点。插入、查找和删除平均 O(1)，容量满时先移除尾节点并清理哈希项。并发实现需保护两种结构的一致性，分片锁会改变全局严格 LRU 语义。 若每次命中都更新链表头，高并发下会形成写竞争，可按分片近似维护。", size: 9.5pt)
  #raw("std::list<std::pair<Key, Value>> lru; // 头最近，尾最久未用\nstd::unordered_map<Key, decltype(lru.begin())> index;\nif (index.contains(key)) { lru.splice(lru.begin(), lru, index[key]); return index[key]->second; }\nif (lru.size() == capacity) { index.erase(lru.back().first); lru.pop_back(); }\nlru.emplace_front(key, value); index[key] = lru.begin(); // 查/移/淘汰平均 O(1)\n// 并发需保护 map 与 list 原子一致；分片锁会变为局部/近似 LRU。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("011  如何设计分布式计数器？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先明确计数是否必须精确、读可否延迟，以及更新是否允许丢失或重复；高写入时可按键分片累加，再在读取或后台聚合时汇总。每个分片用原子更新或可靠消息，并以事件 ID 去重，才能避免重试重复加一。还要定义热点分片、持久化恢复、重置周期和跨分片快照一致性。 热点计数可拆成多个随机后缀分桶，读取时求和并接受短暂汇总延迟。", size: 9.5pt)
  #raw("shard = hash(request_id) % shard_count; // 分散热点写入\nshards[shard].apply_once(request_id, +1); // 单分片原子去重并递增，重试不重复计数\nif (read_total) sum = aggregate_all_shards(); // 汇总可能有短暂延迟\npersist_shard_checkpoints_and_dedup_ids(); // 恢复时既不漏计也不重计\n// 明确计数是否精确、读延迟与跨分片快照一致性\n// 热点可拆多个随机后缀分桶；扩缩分片需迁移去重状态/计数", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("012  如何设计实时排行榜？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  维护成员分数和可排序索引，Redis ZSet 可用 ZADD 更新分数、ZREVRANK 查询名次，适合常见单分片排名。高吞吐时按用户或榜单分区写入，再周期性汇总各分区候选；全局精确排名需要额外协调。设计前要定同分规则、窗口周期、迟到更新、缓存持久化和读写延迟目标。 榜单规模和查询窗口会影响排序结构选择，滑动窗口榜单还要淘汰旧分数。", size: 9.5pt)
  #raw("ZADD(board, score, user_id); // 分数与排序索引一起更新\nrank = ZREVRANK(board, user_id); top = ZREVRANGE(board, 0, K - 1);\n// 先定义同分排序、迟到更新、窗口过期和读延迟目标\nif (single_shard_capacity_exceeded) write_to_partitioned_boards_then_merge_candidates();\n// 分区候选汇总可扩展；全局精确 rank 仍需协调\nif (sliding_window_board) remove_expired_scores_or_events();\n// 还要考虑持久化/重启恢复、排行榜规模和查询频率", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("10.3 高并发、消息与容错", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("013  如何设计高并发秒杀系统？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  静态商品信息由 CDN 承载，入口先鉴权、限流和排队，库存预热后通过原子条件扣减避免超卖。成功请求再异步下单、用消息队列削峰，消费者按请求 ID 幂等处理；数据库更新仍用库存条件和订单唯一约束兜底。需压测热点键与队列积压，并提供失败回滚、超时订单释放和库存对账。 令牌校验和业务资格检查应尽量在入口前完成，减少无效请求争抢库存。", size: 9.5pt)
  #raw("authenticate_and_check_eligibility_before_hot_inventory(); // 过滤无效流量\nif (!rate_limiter.try_acquire(user)) enqueue_or_reject();\nif (atomic_decrement_if_stock_positive(sku, request_id)) publish_order_event();\n// 成功后异步削峰；消费者按 request_id 幂等，订单键有唯一约束。\nif (order_times_out) release_reserved_stock_idempotently();\n// DB 条件更新兜底防超卖；压测热键/积压并做库存对账。", lang: "sql", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("014  常见负载均衡算法有哪些？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  轮询简单，适合实例能力近似的无状态流量；加权轮询可按容量分配，最少连接适用于请求时长差异明显的场景。一致性哈希有利于会话或缓存局部性，随机/延迟感知策略可减轻热点。负载均衡还要结合健康检查、连接池、重试放大和跨区成本，避免把故障实例继续选中。 健康检查应区分进程存活与业务就绪，避免恢复中实例过早接收大流量。", size: 9.5pt)
  #raw("if (instances_have_similar_capacity) choose_round_robin();\nelse if (capacity_weights_known) choose_weighted_round_robin();\nelse if (request_durations_vary) choose_least_connections();\nif (session_or_cache_locality_matters) choose_consistent_hash();\nexclude_if_unhealthy_or_not_ready(); // 活着不等于业务就绪\n// 同时控制重试放大、连接池和跨区成本；策略按实际延迟/负载验证。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("015  微服务相对单体架构有哪些权衡？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  单体部署简单、进程内调用快、事务边界清楚，适合早期团队快速交付；微服务让团队可按边界独立发布、扩缩容，但引入网络失败、接口治理、分布式数据和观测成本。拆分应基于领域与团队所有权，而非按技术层拆很多小服务。需要配套超时、有限重试、熔断、版本兼容和故障定位能力。 服务拆分还会影响数据一致性和本地调试，拆分前先定义清晰的服务边界。", size: 9.5pt)
  #raw("if (team_is_small_and_domain_boundaries_unclear) start_with_modular_monolith();\n// 单体进程内调用快、事务清楚、部署简单。\nif (service_boundary_owned_by_team && independent_release_or_scale_needed) split_service();\n// 微服务引入网络超时、部分失败、数据一致性、观测/发布治理成本。\nadd_deadlines_bounded_retries_circuit_breakers_and_version_compatibility();\n// 按领域与团队所有权拆分，避免按技术层切成大量小服务。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("016  消息队列如何尽量避免消息丢失？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  生产端等待 Broker 确认并启用合适的持久化/副本策略，避免消息只留在客户端缓冲或单个易失节点。消费者应先完成可恢复的业务处理，再提交位点或 ACK；否则先确认后崩溃会丢业务。至少一次投递会重发，所以消费者按消息 ID 幂等、设置重试和死信队列，并监控积压与复制状态。 确认和 ACK 的先后关系决定故障时是可能重复还是可能丢失，需按目标选取。", size: 9.5pt)
  #raw("producer.send(message); await broker_durable_replica_ack(); // 持久化确认后再报成功\nconsumer_result = apply_business_idempotently(message.id, message.payload);\nif (consumer_result.durable) consumer.ack_or_commit_offset(message);\n// 先 ACK 再持久处理会丢业务；先处理后 ACK 崩溃会重放\nretry_with_limit_and_dead_letter_after_policy(); monitor_lag_and_replica_health();\n// 按消息 ID 幂等，监控复制健康/积压；Broker ACK 语义要核对配置\n// 保证边界还依赖副本数、刷盘策略和故障类型", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("017  限流常用算法有哪些？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  固定窗口以简单计数实现，但窗口切换边界可能让短时间请求量接近双倍；滑动日志或计数窗口更平滑但状态更多。令牌桶按速率补充令牌，允许桶容量范围内的突发；漏桶以较稳定速率放行。分布式实现还需定义原子计数、限流状态丢失时的降级以及按用户/接口的公平性。 对突发敏感的入口可用令牌桶，对希望匀速处理的后台任务可用漏桶。", size: 9.5pt)
  #raw("#include <algorithm>\n// 固定窗口易实现，但边界前后短时间内可接近两倍限额\nif (fixed_window_count(key, now) < limit) allow();\n// 令牌桶按 rate 补充，最多 burst_capacity，允许短突发\ntokens = std::min(capacity, tokens + elapsed * rate);\nif (tokens >= 1) { tokens -= 1; allow(); }\n// 滑动日志更精确但状态多；漏桶适合较匀速处理后台任务\n// 分布式还要定义原子更新、公平性和状态丢失时的降级", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("018  高可用系统通常从哪些方面设计？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  高可用从消除单点开始：跨进程/机器冗余、健康检查、故障切换和可恢复的数据备份。调用链配置有限超时、带抖动退避的重试、熔断与降级，避免局部故障扩散；对关键依赖明确 RTO/RPO。监控告警、故障演练和回滚验证机制是否真能在目标时间内恢复。 备份只有通过定期恢复演练验证，才能证明满足恢复时间和数据点目标。", size: 9.5pt)
  #raw("replicate_across_processes_and_failure_domains(); health_check_readiness_and_fail_over();\ncall_dependency_with_deadline(); retry_with_bounded_jittered_backoff();\nif (failure_rate_high) circuit_break_and_serve_degraded_result();\nbackup_data(); periodically_restore_test_and_measure_RTO_RPO();\n// RTO 是恢复所需时间，RPO 是可接受的数据丢失窗口\n// 监控告警、回滚和故障演练验证冗余可恢复，而非只看副本数\n// 备份需定期实测恢复，才能证明目标满足", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("019  高并发 IM 或消息推送服务如何拆分？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  连接网关维护长连接和心跳，认证服务管理身份，路由层定位用户所在网关，消息服务负责持久化、投递、ACK 和离线存储。按会话或用户分片并通过消息队列解耦突发流量，客户端重连后按序号补拉未确认消息。还要处理多端在线、重复投递、消息顺序、离线 TTL 和连接状态过期。 连接网关故障后客户端通常要指数退避重连，避免整群同时冲击认证和路由服务。", size: 9.5pt)
  #raw("gateway.accept_long_connection(); authenticate_and_heartbeat();\nroute = presence_service.locate_user_gateway(user_id);\nmessage_store.persist_with_sequence_and_ttl(message); queue.deliver(route, message);\nif (client_ack(message.id)) mark_delivered_idempotently();\nif (reconnect) backoff_with_jitter(); fetch_messages_after(last_acked_sequence);\n// 设计多端、离线存储、重复投递、顺序和路由状态过期语义。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("020  高并发日志系统要考虑哪些模块？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  日志先经过异步有界队列，由后台批量格式化并写文件或远端，降低业务线程的 I/O 等待。队列满时要明确阻塞、丢低级别日志或采样策略；配置轮转、刷盘和进程退出时的有序 flush。日志记录请求 ID、时间和线程信息，但应避免敏感数据，并监测队列深度和丢弃数。 日志队列采用有界容量，才能在异常高峰时限制内存增长并形成可观测背压。", size: 9.5pt)
  #raw("if (pending.size() == capacity) apply_block_drop_low_level_or_sample_policy(record);\nelse pending.push(record); // 业务线程只排入有界异步队列\nbackground_worker.batch_format_and_write_file_or_remote();\nrotate_logs_and_flush_by_durability_policy();\non_shutdown_flush_then_join_worker();\n// 记录 request ID/时间/线程但脱敏；监控队列深度、丢弃量和写入错误。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("021  高并发网络服务器通常如何设计？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  事件循环用非阻塞 socket 处理连接建立、读写和定时器，工作线程池执行计算密集或可能阻塞的业务，避免卡住 I/O 线程。连接数、待处理任务、缓冲区和单请求执行时间都要设上限，并实现背压、超时和优雅关闭。通过压测与 profiling 找到瓶颈后再决定线程数、进程模型和 CPU 亲和性。 事件循环不应执行同步磁盘访问或无界计算，否则一个任务会阻塞同循环其他连接。", size: 9.5pt)
  #raw("while (running) { auto ready = poller.wait(deadline);\n    for (event : ready) handle_nonblocking_socket(event); // I/O 线程保持轻量\n    submit_cpu_or_blocking_work_to_bounded_pool(); // 防止磁盘/业务阻塞事件循环\n    apply_backpressure_to_connection_and_task_queues(); expire_slow_requests(); }\n// 限连接、缓冲与执行时长；优雅关闭时停止接入、排空任务并回收线程。\n// 压测/profiling 后再调线程数、进程模型与 CPU 亲和性。", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("10.4 共识与消息一致性", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("022  Raft 共识算法由哪些核心部分组成？多数派有什么作用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Raft 将复制状态机共识分解为领导者选举、日志复制和安全性规则；领导者接收命令并复制日志，通常复制到多数派后条目才能提交并应用。多数派相交使新领导者能继承已提交条目；网络分区中失去多数派的一侧不能提交新写入。多数派提供安全提交条件，不等于每个节点时刻拥有相同最新状态。 日志提交受任期和前序日志匹配规则约束，不能只凭副本数就认定任意条目已提交。〔S11〕", size: 9.5pt)
  #raw("leader = elect_by_term_and_timeout(); // 领导者接收命令\nleader.append_log(entry); replicate_to_followers(entry);\nif (replicated_to_majority && raft_term_and_prefix_rules_hold) commit(entry);\napply_committed_entries_to_state_machine();\n// 多数派交集让新领导者能继承已提交日志；少数派不能提交新写。\n// 多数不代表每个节点总有最新状态，提交还受任期/日志匹配规则约束。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("023  Transactional Outbox 如何解决数据库更新与发消息之间的双写问题？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  业务更新与待发事件写入同一数据库事务，避免业务表提交成功但进程在发消息前崩溃的双写窗口。后台轮询或 CDC 读取 Outbox 并投递消息，发送失败可重试，因此同一事件可能被重复发送。消费者需按事件 ID 幂等处理；还要处理 Outbox 清理、发布顺序、积压监控和数据库到 Broker 的延迟。〔S13〕", size: 9.5pt)
  #raw("BEGIN;\nUPDATE orders SET status = 'paid' WHERE id = ?;\nINSERT INTO outbox(event_id, topic, payload) VALUES (?, 'OrderPaid', ?);\nCOMMIT; -- 业务状态与事件原子提交，避免 DB 成功但进程发消息前崩溃\npublisher.read_unpublished_rows_and_send(); mark_published_after_broker_ack();\n-- 发送失败会重试，消费者按 event_id 幂等；监控积压、顺序和清理。", lang: "sql", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("024  消息系统里的“恰好一次”语义通常有什么边界？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  “恰好一次”要说明是生产者写入日志、Broker 内消费，还是连外部数据库副作用也包括。Kafka 幂等生产者可避免重试造成同一分区重复记录，事务可把多分区输出和消费位点原子提交，并由 read_committed 消费已提交数据。若业务还写外部数据库，仍需事务性 Sink、Outbox 或幂等键，不能由 Kafka 单独保证端到端只执行一次。〔S12〕", size: 9.5pt)
  #raw("producer.enable_idempotence(); // 去除生产重试带来的同分区重复记录\nbegin_broker_transaction(); write_output_records(); commit_consumed_offsets_atomically();\nconsumer.read_committed(); // 只读已提交事务数据\n// 若还写外部数据库，Kafka 事务不能把 DB 副作用纳入同一原子提交。\nuse_transactional_sink_or_outbox_or_idempotency_key_for_external_effect();\n// 先说清“一次”覆盖生产、Broker 内消费，还是端到端业务副作用。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("025  分布式系统中的熔断器是什么？Closed、Open 和 Half-Open 状态如何工作？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  熔断器统计依赖调用结果：Closed 正常转发并累计失败率，达到阈值后进入 Open，快速拒绝请求以给下游恢复空间。冷却后进入 Half-Open，只放少量探测请求；成功则关闭并恢复流量，失败则重新打开。熔断不是重试：重试增加调用次数，熔断在故障持续时减少调用，通常还需配合超时、降级和监控。〔S15〕", size: 9.5pt)
  #raw("switch (state) { // 每次请求只执行当前状态的一条路径\ncase Closed: forward_call_and_record_result();\n    if (failure_rate() > threshold) state = Open; break;\ncase Open: fail_fast_or_degrade();\n    if (now >= cooldown_end) state = HalfOpen; break;\ncase HalfOpen:\n    if (allow_limited_probe()) state = probe_succeeds() ? Closed : Open;\n    break;\n}\n// Open 降低持续故障时的下游调用；Half-Open 限量探测恢复情况\n// 熔断不是重试；失败可延长冷却，并配合超时、降级和指标告警", lang: "cpp", block: true)
]

#heading(level: 1, outlined: true)[#text("第11章 自动驾驶与实时数据", size: 15pt, weight: "bold", fill: rgb("#000000"))]
#heading(level: 2, outlined: true)[#text("11.1 QoS 与点云处理", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  ROS 2 DDS 的 QoS 如何按数据类型选择？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  ROS 2 QoS 由 History/Depth、Reliability、Durability、Deadline 等策略组合而成，发布者和订阅者的配置还必须兼容。高频相机或点云通常更看重最新帧，可选 BestEffort 和较浅队列，避免排队传旧数据；关键控制命令可考虑 Reliable，但重试延迟和资源占用也要纳入时限分析。最终选择应在目标 DDS 实现、网络和负载下验证。", size: 9.5pt)
  #raw("camera_qos = {BestEffort, KeepLast, depth=1, deadline=frame_period}; // 保新帧\ncontrol_qos = {Reliable, KeepLast, bounded_depth}; // 关键指令要可靠但受时限约束\nif (!publisher_qos_compatible_with(subscriber_qos)) no_samples_are_delivered();\n// History/Depth、Reliability、Durability、Deadline 策略须兼容\n// 队列太深会积压旧图像；Reliable 重试也会增加时延和资源占用\n// 在目标 DDS、网络和负载下测延迟/丢帧，再按数据重要性定配置", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  体素网格降采样如何实现？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  把每个点的坐标按体素边长量化为三维整数索引，以索引为哈希键累计坐标和计数，最后输出每格质心，可显著减少点数。扫描 n 个点平均 O(n)，内存与非空体素数相关；稀疏数据适合哈希表，规则小范围也可用数组。体素越大降采样越强，但边缘、细小障碍和定位精度会损失。 质心并非原始点，若后续算法依赖表面边缘，可改为保留代表点或自适应叶尺寸。", size: 9.5pt)
  #raw("#include <cmath>\n#include <unordered_map>\nstd::unordered_map<Cell, SumAndCount, CellHash> voxels;\nfor (const Point& p : cloud) {\n    Cell c{std::floor(p.x / size), std::floor(p.y / size), std::floor(p.z / size)};\n    voxels[c].add(p); // 相同体素累计坐标和计数，floor 也正确处理负坐标\n}\nfor (const auto& [cell, aggregate] : voxels) output.push_back(aggregate.centroid());\n// 平均 O(n)，内存随非空体素数增长；体素越大细节/边缘精度损失越明显\n// 质心不是原始点；依赖表面边缘时可保留代表点或自适应叶尺寸", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("11.2 共享内存与时钟同步", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  共享内存传递大帧如何管理所有权？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  生产者把帧写入共享内存池，向消费者传递槽位索引、长度、版本和时间戳等轻量句柄，避免跨进程复制大图像。通过引用计数、所有权转移或租约状态确保消费者读完前槽位不会被复用，并用原子状态避免读写竞争。进程异常退出时要有超时回收机制，且映射地址不能假设各进程相同。 还应验证缓存对齐、像素步长和 NUMA 放置，避免零拷贝后仍发生隐式复制。", size: 9.5pt)
  #raw("slot = shared_pool.acquire(); producer.write_frame(slot); // 跨进程只传句柄而非复制大帧\npublish({slot.index, slot.generation, length, timestamp, stride});\nconsumer.map_own_address_and_validate_layout(handle); consumer.retain(slot);\nif (consumer_done) release_reference(slot); // 引用归零/所有权归还前不能复用\nif (owner_crashed_or_lease_expired) reclaim_after_safe_recovery();\n// 共享槽位状态需原子同步；检查步长、缓存对齐、NUMA 和隐式复制。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  多传感器如何做时间同步？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  最可靠的同步是传感器共用硬件触发或 PPS；分布式设备可用 PTP/gPTP 校准时钟，采集端尽量记录硬件时间戳而非软件收到时间。算法融合时统一时钟域，并估计固定偏移与随时间变化的漂移。还应明确图像曝光中点、雷达扫描周期等时间定义，启动时对齐一次无法消除长期漂移。 融合时通常按时间戳做插值或最近邻匹配，并设置最大允许时间差。", size: 9.5pt)
  #raw("capture_hardware_timestamp(sensor); // 比应用收到回调时间更接近实际采集\nsynchronize_clocks_with_hardware_trigger_or_PPS_or_PTP();\nestimate_clock_offset_and_drift_over_time();\nnormalize_to_common_clock_domain(); // 明确曝光中点/扫描周期等时间定义\nframe = nearest_or_interpolate(sensor_a, sensor_b, max_allowed_skew);\n// 只启动时校一次不能消除长期漂移；融合需设最大时间差。", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("11.3 实时数据流水线", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  实时传感器数据流水线如何避免阻塞和积压？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  把采集、校时、预处理、融合/推理和输出拆成独立阶段，各阶段用有界队列隔离速度波动。队列满时按数据类型规定丢最旧帧、丢最新帧或背压；实时感知常需优先保持新鲜度，不能无限积压旧帧。记录每阶段时间戳并监控端到端 P95/P99 延迟、丢帧和队列深度，设置过期数据截止时间。 对控制链路可为每帧设置截止时间，超时结果直接作废而不进入下游队列。", size: 9.5pt)
  #raw("capture -> bounded_queue -> timestamp_and_preprocess -> fusion_or_inference -> output;\nif (queue.full()) drop_oldest_or_newest_or_apply_backpressure_by_data_type();\nif (now - frame.timestamp > deadline) discard_expired_frame();\nrecord_each_stage_timestamp_and_queue_depth();\nalert_on_p95_p99_latency_drops_and_backlog();\n// 实时感知常优先新鲜度，不能无限排旧帧；策略按链路安全要求设定。", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  工业相机图像采集与处理系统如何设计？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  采集线程专注从相机 SDK 取缓冲区并记录硬件时间戳，处理线程通过有界队列分阶段做去马赛克、校正或检测。大帧可用共享池/引用句柄减少复制，同时校验像素格式、步长、尺寸和缓冲生命周期。负载超限时应明确丢弃过期帧策略，并监控丢帧率、处理尾延迟、CPU/GPU 和内存占用。 缓冲区不足时记录设备端丢帧计数，才能区分采集丢失与处理来不及。", size: 9.5pt)
  #raw("frame = camera_sdk.acquire_buffer(); timestamp = frame.hardware_timestamp();\nif (!bounded_queue.try_push({frame_handle, timestamp, format, stride, dimensions})) count_drop();\nworker_demosaic_rectify_and_detect(frame_handle); // 句柄复用可减少大帧复制\nvalidate_pixel_format_stride_dimensions_and_buffer_lifetime();\nif (processing_is_late) drop_expired_frame_and_record_stage_latency();\n// 分开采集/处理线程，避免耗时算法阻塞 SDK 取帧\n// 记录设备端丢帧计数，区分采集丢失与处理积压\n// 监控 CPU/GPU、内存、丢帧和 P99；队列有界避免无界缓存", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("007  生产者永不阻塞的帧环形队列如何设计？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  使用固定槽位帧池保存大帧，生产者只发布槽位序号和代际号，避免在采集路径等待消费者或复制图像。单消费者可用序号协议区分新旧数据，覆盖前需确认读者不会再访问；多消费者还需分别跟踪读位置或用引用计数安全回收。若采用丢旧帧保持实时性，消费者应能检测序号跳跃并统计丢帧。 无锁实现需用适当内存序发布槽位内容，并避免序号回绕造成 ABA 误判。", size: 9.5pt)
  #raw("slot = fixed_pool.acquire_without_wait(); if (!slot) return DropAndCount;\nwrite_frame(slot.buffer); slot.sequence = next_sequence.fetch_add(1);\nslot.state.store(Ready, std::memory_order_release); // 内容写完再发布 ready\nconsumer.load_state(std::memory_order_acquire); verify_generation_and_sequence();\nif (reader_finished) release_slot(); // 槽位回收前确认无消费者仍持有\n// 固定槽避免大帧复制，生产者不等待；消费者靠序号发现覆盖/丢帧\n// 多消费者要追踪每个读位置或引用数；序号回绕需防 ABA\n// 超时回收需确认进程已不再访问映射，不能仅因租约过期就覆盖", lang: "cpp", block: true)
]

#heading(level: 1, outlined: true)[#text("第12章 C++ 进阶与工程", size: 15pt, weight: "bold", fill: rgb("#000000"))]
#heading(level: 2, outlined: true)[#text("12.1 内存模型与缓存一致性", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  C++ 中 CPU 缓存一致性和 false sharing 是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  缓存一致性协议协调不同 CPU 核心对同一缓存行的读写副本，使写入最终保持一致。false sharing 指线程改写不同变量，但变量恰好落在同一缓存行，导致缓存行在核心间反复转移，性能下降而非数据竞争。可将热点计数器分离或按平台硬件间隔对齐，并用 profiler 验证是否值得增加内存。", size: 9.5pt)
  #raw("#include <atomic>\n#include <cstdint>\n#include <thread>\nstruct alignas(64) PaddedCounter { std::atomic<std::uint64_t> value{0}; };\nPaddedCounter counters[2];\nstd::jthread a([&] { ++counters[0].value; });\nstd::jthread b([&] { ++counters[1].value; });\n// 逻辑独立但同缓存行会反复转移，形成 false sharing 性能损失\n// 64 是平台假设；对齐会增加内存，应先用 profiler/硬件常量验证", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  C++ 中 volatile 与 std::atomic 有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  volatile 限制某些对 volatile 对象访问的优化，常用于平台定义的内存映射寄存器；它不保证原子性、线程间顺序或可见性。std::atomic 为并发访问提供原子操作及内存序，适合线程共享状态，但不能自动保护多个字段组成的不变量。普通共享变量有未同步冲突访问会构成数据竞争。", size: 9.5pt)
  #raw("#include <atomic>\n#include <cstdint>\nvolatile std::uint32_t* device_register = platform_mapped_register();\n*device_register = command; // volatile 用于平台定义的设备访问语义\nstd::atomic<bool> ready{false}; // 线程共享状态需要原子同步\nready.store(true, std::memory_order_release);\nif (ready.load(std::memory_order_acquire)) consume_published_data();\n// volatile 不保证原子性、线程可见性或 happens-before；atomic 也不保护多字段", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  C++ 内存模型中的 happens-before 是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  happens-before 是 C++ 内存模型用来定义操作顺序和可见性的关系：同一线程的先后求值形成 sequenced-before，线程间通过互斥锁、release/acquire 等同步操作建立跨线程关系。发布线程先写数据再 release，读取相应发布值的 acquire 线程可见这些写入。缺少关系的冲突非原子访问会产生数据竞争。", size: 9.5pt)
  #raw("#include <atomic>\n#include <thread>\nint payload = 0; std::atomic<bool> published{false};\nstd::thread producer([&] { payload = 42; published.store(true, std::memory_order_release); });\nwhile (!published.load(std::memory_order_acquire)) {} // 观察到发布值\nint value = payload; // 写入 happens-before 此读取\nproducer.join(); // acquire/release 同步普通数据访问；join 回收线程", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("12.2 模板、容器与线程安全", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  SFINAE 是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  SFINAE 是 Substitution Failure Is Not An Error：在模板候选的替换阶段，特定替换失败会让该候选从重载集中移除，而不是立即使程序报错。它常用于检测成员或限制模板参数，但错误信息可能难读。C++20 concepts 可将条件直接写成 requires 约束；仍需理解替换失败与函数体实例化失败的区别。", size: 9.5pt)
  #raw("#include <type_traits>\n#include <utility>\n#include <vector>\ntemplate<class T, class = void> struct has_size : std::false_type {};\ntemplate<class T> struct has_size<T, std::void_t<decltype(std::declval<T>().size())>> : std::true_type {};\nstatic_assert(has_size<std::vector<int>>::value); // 无 size() 的类型选主模板\n// 替换失败才会从候选集中移除；函数体实例化失败不自动算 SFINAE\n// C++20 requires/concepts 更直观表达约束，但旧代码仍会遇到 SFINAE", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  STL 容器的线程安全边界是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  标准库容器允许符合规则的并发 const 操作；除 vector<bool> 这类特殊打包表示外，对不同元素的某些并发修改也可不互相构成数据竞争。但插入、删除、扩容等会改变容器结构的操作，与遍历或访问通常需外部同步。多个线程写同一元素、或读写同一元素冲突时也要加锁或改用原子设计。", size: 9.5pt)
  #raw("#include <thread>\n#include <vector>\nstd::vector<int> values{1, 2, 3, 4};\nstd::jthread a([&] { values[0] = 10; });\nstd::jthread b([&] { values[1] = 20; }); // 修改不同普通元素\n// 两个线程不应同时 push_back/resize 与遍历：结构和迭代器会改变\n// 写同一元素需同步；vector<bool> 位打包有特殊风险\n// 并发 const 访问也不能与未同步结构修改同时进行", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  shared_ptr 是线程安全的吗？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  多个不同 shared_ptr 实例若共享一个控制块，其引用计数增减可并发进行；这不代表同一个 shared_ptr 变量可被多个线程同时读写。对同一实例并发赋值要加锁，或在支持的标准版本使用 atomic<shared_ptr>。无论如何，所指对象内部状态的线程安全仍由程序自行保证。", size: 9.5pt)
  #raw("#include <memory>\n#include <thread>\nstd::shared_ptr<Widget> shared = std::make_shared<Widget>();\nstd::shared_ptr<Widget> left = shared, right = shared;\nstd::jthread a([copy = left] { use(copy); }); // 独立 shared_ptr 实例\nstd::jthread b([copy = right] { use(copy); }); // 共享控制块计数可并发更新\n// 同一个 shared_ptr 变量若同时读写仍需同步；Widget 内部也要自行保护", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("007  std::function 与模板回调有什么取舍？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  std::function 通过类型擦除提供固定签名，适合回调需跨模块保存不同闭包类型的接口；会有间接调用，某些目标可能触发动态分配，但具体优化依实现。模板回调保留具体类型，更容易内联且可编译期检查，但会增加实例和接口暴露。需要运行时异构存储时选 function，局部泛型算法常用模板。", size: 9.5pt)
  #raw("#include <functional>\n#include <utility>\nstd::function<void(Event)> callback = [state](Event e) { state.handle(e); };\nregistry.add(callback); // 固定签名，可运行时存不同闭包类型\n// 类型擦除带间接调用；目标可能分配，SBO 依具体实现\nauto templated_call = [](auto&& f, auto&& value) {\n  std::forward<decltype(f)>(f)(\n      std::forward<decltype(value)>(value));\n};\ntemplated_call([](Event e) { handle(e); }, event); // 具体类型利于内联\n// 异构长期存储用 function；局部泛型算法通常用模板", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("008  std::vector 扩容和迭代器失效有什么影响？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  vector 容量不足时通常申请新缓冲区并迁移元素，扩容会使其元素指针、引用和迭代器失效；尾部插入平均摊还 O(1)，单次扩容仍为 O(n)。已知大致规模可 reserve 减少重分配。erase 会移动后续元素，因此被删位置及其后的迭代器/引用失效，遍历删除应使用返回的新迭代器。", size: 9.5pt)
  #raw("#include <vector>\nstd::vector<Item> items;\nitems.reserve(100); // 已知规模时预留，降低扩容次数\nitems.push_back(first);\nauto it = items.begin();\nitems.push_back(next); // 若容量不足扩容，全部元素迭代器/指针/引用失效\n// reserve 只降低失效概率；erase 也会使删除点及之后句柄失效", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("12.3 零拷贝、异常与并发问题", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("009  如何实现零拷贝？零拷贝是否意味着完全不复制？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  零拷贝通常表示减少某段数据路径上的 memcpy，例如内核 sendfile、mmap、共享内存或设备 DMA；它不一定代表数据没有搬动或复制。系统仍可能复制页表、增加引用计数、进行格式转换或由设备搬运数据。要确认具体路径，并正确管理缓冲区所有权、生命周期、同步和背压。", size: 9.5pt)
  #raw("#include <cstddef>\n#include <span>\n#include <vector>\nvoid checksum(std::span<const std::byte> bytes) { consume(bytes); }\nstd::vector<std::byte> buffer = read_once(); checksum(buffer); // 借用缓冲，不复制字节\n// mmap/sendfile/共享内存可减少特定路径 memcpy，但页表/DMA 仍有成本\n// 仍须保证 buffer 生命周期、所有权移交、并发访问和背压", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("010  异常安全的三个常见保证是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  不抛出保证表示操作不会让异常逃出；强保证表示失败时程序状态不变；基本保证表示对象仍有效且资源无泄漏，但状态可改变。RAII 管理资源，先构造临时结果再提交可帮助实现强保证，copy-and-swap 是一种例子。noexcept 是可观察承诺，异常逃逸会 terminate，不能为优化而随意标记。", size: 9.5pt)
  #raw("class Value { public:\n  Value& operator=(const Value& other) {\n    Value temp(other); // 强保证：复制失败时当前状态不变\n    swap(*this, temp); return *this; // ADL 选本类的非抛出 friend swap\n  }\n  friend void swap(Value&, Value&) noexcept;\n};\n// 基本保证：对象有效且无泄漏；不抛出保证：异常不外传\n// noexcept 只有操作真实不抛时才能承诺", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("011  无锁队列中的 ABA 问题是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  CAS 读取到 A 后，其他线程可能先把状态改成 B，再改回 A，比较时仍相等，算法误以为状态没有变化；无锁栈中节点地址复用是典型情况。带版本计数的指针可检测部分 ABA，hazard pointer 或 epoch 回收避免节点过早释放。标记位宽和回绕也需考虑，且必须一并证明内存回收安全。", size: 9.5pt)
  #raw("#include <atomic>\n#include <cstdint>\nstruct TaggedHead { Node* ptr; std::uint64_t version; };\nstd::atomic<TaggedHead> head; // CAS 同比地址和版本，部分检测 ABA\nbool replace(TaggedHead old, Node* next) {\n  TaggedHead desired{next, old.version + 1};\n  return head.compare_exchange_strong(old, desired);\n}\n// 仍需 hazard pointer/epoch 确保 Node 未提前释放；版本会回绕且未必 lock-free", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("012  移动构造为什么常标记 noexcept？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  vector 扩容要在移动元素途中遇到异常时维持异常保证；若移动构造可能抛且元素可拷贝，库实现可选择拷贝以保留强保证。noexcept 移动允许实现安全地移动，降低回退拷贝的需要。只有所有移动步骤确实不会抛时才能标记 noexcept，否则异常逃出会导致 terminate。", size: 9.5pt)
  #raw("#include <utility>\n#include <vector>\nstruct Item { std::vector<int> data;\n  Item(Item&& other) noexcept : data(std::move(other.data)) {} // 移动确实不抛\n};\nstd::vector<Item> items; items.reserve(100); // 降低扩容搬移次数\n// move 可能抛而 copy 可用时，vector 为强保证可能选择 copy\n// noexcept 错误标注会让逃逸异常调用 terminate", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("013  结构体成员重排为什么可能节省内存？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  成员地址必须满足各自对齐要求，编译器会在成员间和对象末尾插入填充；把高对齐成员放在前面有时能减少空隙，例如先放 8 字节成员再放 1 字节成员。重排会改变 sizeof、成员偏移和 ABI，也可能破坏外部二进制协议。对持久化或网络数据应显式序列化，不依赖内存布局。", size: 9.5pt)
  #raw("#include <cstddef>\nstruct Before { char tag; double value; int count; };\nstruct After { double value; int count; char tag; };\nstd::size_t a = sizeof(Before), b = sizeof(After); // 只比较当前 ABI\n// 成员对齐会插入填充；将高对齐成员前置有时能减少空隙\n// 重排会改变成员偏移/sizeof 并破坏 ABI\n// 网络或持久化数据应显式序列化，不能依赖本机内存布局", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("014  迭代器失效通常如何处理？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  迭代器失效规则按容器和具体操作区分：vector 扩容会使全部失效，插入/删除会影响相应位置之后的元素；list 插入一般不影响其他迭代器，删除只使指向被删节点者失效；unordered 容器 rehash 会使迭代器失效。读取文档并在 erase 中接收返回迭代器，避免继续使用失效句柄。", size: 9.5pt)
  #raw("#include <vector>\nfor (auto it = values.begin(); it != values.end(); ) {\n  if (should_remove(*it)) it = values.erase(it); else ++it;\n}\n// erase 返回下一个有效迭代器，删除后不要再用旧 it\n// vector 扩容使所有迭代器失效；list 插入通常不影响其他节点迭代器\n// unordered_map rehash 会使迭代器失效；具体规则按容器和操作查文档", lang: "cpp", block: true)
]

#heading(level: 1, outlined: true)[#text("第13章 数据结构与算法", size: 15pt, weight: "bold", fill: rgb("#000000"))]
#heading(level: 2, outlined: true)[#text("13.1 基础动态规划与数组问题", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  0/1 背包问题（0/1 Knapsack）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  令 dp[c] 表示当前已处理物品在容量不超过 c 时的最大价值，初值为 0。每件重量 w、价值 v 的物品按 c 从 W 递减到 w 更新，避免本轮结果重复使用该物品；若正序更新就变成完全背包。时间 O(nW)、空间 O(W)，重量为零时要按题目约束避免无限取用。 物品重量大于当前容量时自然跳过，初始化为零也适用于允许不选任何物品的情形。", size: 9.5pt)
  #raw("// dp[c] 只由已经处理的物品决定，容量倒序是 0/1 约束的关键。\n// dp[c]：已处理物品在容量不超过 c 时的最大价值；允许不选物品\nstd::vector<long long> dp(W + 1, 0);\nfor (const auto& item : items) {\n    for (int c = W; c >= item.weight; --c) // 倒序保证本轮不会重复用同件物品\n        dp[c] = std::max(dp[c], dp[c - item.weight] + item.value);\n}\nreturn dp[W]; // O(nW) 时间、O(W) 空间；重量为 0 时需按约束处理", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  K 个一组翻转链表的思路是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先从组首向后数满 K 个节点；不足 K 个时直接返回，保留尾段原样。对整组用 prev/current/next 反转指针，随后把前一组尾接到新组首，并把旧组首作为新组尾连接剩余链表。虚拟头节点可统一处理首组，迭代法时间 O(n)、额外空间 O(1)。 每段反转前后都要保存连接点，避免链表被截断或下一组失去入口。", size: 9.5pt)
  #raw("// prev/cur/next 维护组内反转；组外连接点必须先保存。\n// dummy 统一处理首组；不足 k 个的尾段不反转\nNode dummy{0, head}; Node* before = &dummy;\nwhile (true) { Node* end = before; for (int i = 0; i < k && end; ++i) end = end->next;\n    if (!end) break; Node* oldFirst = before->next; Node* prev = end->next; Node* cur = oldFirst;\n    while (cur != end->next) { Node* next = cur->next; cur->next = prev; prev = cur; cur = next; }\n    before->next = end; before = oldFirst;\n}\nreturn dummy.next; // 每个节点只改指针，O(n) 时间、O(1) 额外空间", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  三数之和如何去重并求解？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先排序，再固定 i，并用左右指针在剩余区间找和为目标的两数；和小于目标左指针右移，大于则右指针左移。找到后记录三元组并跳过重复的 i、left、right 值，避免重复答案。时间 O(n²)，求和前转成 64 位以防溢出，结果中三数可按题目要求排序输出。 排序后若当前固定值已大于目标且全为非负数，可提前结束枚举。", size: 9.5pt)
  #raw("// 固定首数后双指针单调逼近目标，排序后同值结果要去重。\nstd::sort(a.begin(), a.end());\nfor (int i = 0; i + 2 < a.size(); ++i) { if (i && a[i] == a[i - 1]) continue;\n    int l = i + 1, r = a.size() - 1;\n    while (l < r) { long long sum = (long long)a[i] + a[l] + a[r];\n        if (sum < target) ++l; else if (sum > target) --r;\n        else { out.emplace_back(a[i], a[l], a[r]); int x = a[l], y = a[r];\n            while (l < r && a[l] == x) ++l;\n            while (l < r && a[r] == y) --r;\n        }\n    }\n} // O(n²)；求和先扩为 64 位，避免整数溢出", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  不同路径数（Unique Paths）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  状态 dp[i][j] 表示到达格子 (i,j) 的路径数，最后一步只能从上方或左方进入，因此两者相加。首行和首列没有障碍时只有一条路径，遇障碍则当前状态为 0。滚动一维数组按行更新，时间 O(mn)、空间 O(n)；若网格有障碍，转移同样适用。 路径数量增长很快，网格较大时应使用足够宽的整数类型。", size: 9.5pt)
  #raw("// 一维 dp[c] 在本行代表左侧，尚未覆盖时代表上方。\n// dp[c]：当前行到列 c 的路径数；障碍格状态为 0\nstd::vector<long long> dp(n, 0);\nfor (int r = 0; r < m; ++r) for (int c = 0; c < n; ++c) {\n    if (grid[r][c] == '#') dp[c] = 0;\n    else if (r == 0 && c == 0) dp[c] = 1;\n    else dp[c] += c ? dp[c - 1] : 0; // 旧 dp[c] 是上方，已更新 dp[c-1] 是左方\n}\nreturn dp[n - 1]; // O(mn) 时间、O(n) 空间；路径数大时选宽整数", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  买卖股票的最佳时机（Best Time to Buy and Sell Stock）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  只允许一次买入和卖出时，遍历价格并维护此前最低买入价，当前价减最低价就是以当天卖出能获得的最大收益。先计算收益再更新最低价可避免同一天买卖的歧义；若题目允许同日按规则处理即可。时间 O(n)、空间 O(1)，所有价格单调下跌时返回 0。 最低价只从此前日期更新，避免把未来价格误当成买入价。 例如价格先跌后涨时会在后续卖出点更新利润，反向顺序则保持零收益。", size: 9.5pt)
  #raw("// lowest 始终是当前卖出日之前的最低价格。\nif (prices.empty()) return 0;\nint lowest = prices[0], best = 0;\nfor (int p : prices) {\n    best = std::max(best, p - lowest); // 先卖出计算，再把当天纳入未来买入价\n    lowest = std::min(lowest, p);\n}\nreturn best; // 一次遍历、O(1) 空间；下跌行情返回 0", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("13.2 树与图的遍历", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  二分图检测（Bipartite Graph Detection）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  从每个未染色节点启动 BFS/DFS，给起点染一种颜色，并把每条边的另一端染成相反颜色；遇到同色相邻点就不是二分图。遍历所有连通分量，孤立点可单独构成一侧；自环会立即冲突。时间 O(V+E)、空间 O(V)，常用于判断二分匹配建模是否成立。 用邻接表可在线性规模上完成染色，邻接矩阵会多出 O(V²) 扫描。", size: 9.5pt)
  #raw("// 相邻点必须异色；每个连通分量都要独立启动染色。\nstd::vector<int> color(n, -1); std::queue<int> q;\nfor (int start = 0; start < n; ++start) if (color[start] < 0) { color[start] = 0; q.push(start);\n    while (!q.empty()) { int u = q.front(); q.pop();\n        for (int v : graph[u]) {\n            if (color[v] < 0) { color[v] = color[u] ^ 1; q.push(v); }\n            else if (color[v] == color[u]) return false; // 自环也会冲突\n        }\n    }\n}\nreturn true; // 每个分量染色通过即为二分图，O(V+E) 时间、O(V) 空间", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("007  二叉搜索树的第 k 大元素", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  BST 中序遍历是升序，反向中序按右、根、左访问即为降序；访问计数到 k 时即可停止，避免遍历整棵树。时间为 O(h+k) 左右、递归栈 O(h)，极端偏斜树仍可能到 O(n)。若 k 越界或树可能含重复值，应按题目约定处理。 若树节点不可变，也可维护大小为 k 的最小堆，但需 O(k) 空间。", size: 9.5pt)
  #raw("// 右根左顺序形成降序访问，计数到 k 后可提前终止。\n// 反向中序为降序；假设 k 从 1 开始且 1 <= k <= 节点数\nvoid visit(Node* p) { if (!p || found) return; visit(p->right);\n    if (!found && --k == 0) { answer = p->value; found = true; }\n    visit(p->left);\n}\nvisit(root); // O(h+k) 量级的提前停止遍历，递归栈 O(h)\n// 若 k 越界由 found=false 表示未找到；极斜树可改显式栈", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("008  二叉树的前序、中序、后序遍历如何实现？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  递归遍历分别按根左右、左根右、左右根访问；迭代前序用栈先压右再压左，中序用栈一路走到最左，后序可用双栈或修改访问标记。层序遍历用队列逐层取节点。所有遍历时间 O(n)，深度优先递归/栈空间 O(h)，退化树要留意递归栈溢出。 后序单栈实现需记录上次访问的右子树，防止根节点重复处理。 若只需要某一种遍历，避免同时构造所有序列可减少不必要的内存分配。", size: 9.5pt)
  #raw("// 递归位置决定根左右三种访问次序，空节点是递归边界。\nvoid preorder(Node* p) { if (!p) return; out.push_back(p->value); preorder(p->left); preorder(p->right); }\nvoid inorder(Node* p) { if (!p) return; inorder(p->left); out.push_back(p->value); inorder(p->right); }\nvoid postorder(Node* p) { if (!p) return; postorder(p->left); postorder(p->right); out.push_back(p->value); }\n// 分别按根左右、左根右、左右根访问；每次遍历 O(n)，递归栈 O(h)\n// 极深退化树可用显式栈避免递归深度过大", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("009  二叉树的层次遍历", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  把根节点入队，每轮先记录当前队列长度作为本层节点数，再恰好弹出这些节点并将左右孩子入队，就能按层输出。队列保证先访问较浅节点，空树直接返回空结果。时间 O(n)，最坏队列空间 O(w)，w 为最大层宽；需要每层分组时按轮次切片。 入队时标记访问状态，尤其对图层次遍历可避免同节点重复入队。 该队列在宽而浅的树上可能占用 O(n) 空间，深树则通常明显更省。", size: 9.5pt)
  #raw("// 每轮固定队列长度，保证本层节点与新入队孩子不混淆。\nif (!root) return levels; // 空树返回空列表\nstd::queue<Node*> q; q.push(root);\nwhile (!q.empty()) { int width = q.size(); std::vector<int> level;\n    while (width-- > 0) { Node* p = q.front(); q.pop(); level.push_back(p->value);\n        if (p->left) q.push(p->left); if (p->right) q.push(p->right); }\n    levels.push_back(std::move(level)); // 本轮固定 width，孩子留到下一层\n}\n// 每节点入队一次：O(n) 时间，队列最多 O(w) 个节点", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("010  二叉树的最大深度", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  定义深度为根到最远叶子的节点数，空树深度为 0，则节点深度是 1 加左右子树深度的较大值。DFS 每个节点只访问一次，时间 O(n)、栈空间 O(h)。若题目把路径长度定义为边数，返回值会比节点数少 1，需先确认约定。 对极深输入可改为显式栈，避免递归深度超过语言运行环境限制。", size: 9.5pt)
  #raw("// 深度按节点数定义，空子树返回 0。\nint depth(Node* p) {\n    if (!p) return 0; // 按节点数计深度，空树为 0\n    int left = depth(p->left), right = depth(p->right);\n    return 1 + std::max(left, right);\n}\n// 每节点访问一次，O(n) 时间、O(h) 递归空间；按边计时定义会不同", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("011  二叉树的最大路径和", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  对每个节点递归求左右子树能向上贡献的最大单边和，负贡献截为 0，因为路径可不选该侧。用 left+right+node 更新全局最大值，返回父节点时只能选一侧延伸，避免分叉路径。时间 O(n)、空间 O(h)，全负树要用负无穷初始化全局答案，不能默认为 0。 路径可以不经过根节点，因此答案与返回父节点的单边贡献要分开维护。", size: 9.5pt)
  #raw("// best 是路径可在当前节点拐弯的答案，返回值只能向父节点单边延伸。\nlong long gain(Node* p) { if (!p) return 0;\n    long long left = std::max(0LL, gain(p->left));\n    long long right = std::max(0LL, gain(p->right));\n    best = std::max(best, p->value + left + right); // 以 p 为拐点的完整路径\n    return p->value + std::max(left, right); // 向父节点只能延伸一侧\n}\nlong long best = std::numeric_limits<long long>::lowest(); gain(root);\n// 全负树不能把 best 初始化成 0；时间 O(n)、栈 O(h)", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("012  二叉树的最小深度", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  最小深度必须从根走到叶子，叶子定义为左右孩子都为空；节点只有一个孩子时不能把空子树深度当作答案。递归可在单侧为空时沿非空侧继续，否则取较小深度加一。时间 O(n)、栈空间 O(h)，也可 BFS 首次遇到叶子就返回。 BFS 按深度递增扩展，通常比 DFS 更早找到最近叶子并提前返回。 例如根只有左孩子时，答案应沿左侧继续计算，而不能把空右侧算成深度 1。", size: 9.5pt)
  #raw("// 只有左右孩子均空才是叶子；BFS 按深度递增弹出。\nif (!root) return 0;\nstd::queue<std::pair<Node*, int>> q; q.push({root, 1});\nwhile (!q.empty()) { auto [p, d] = q.front(); q.pop();\n    if (!p->left && !p->right) return d; // BFS 首个叶子就是最近叶子\n    if (p->left) q.push({p->left, d + 1}); if (p->right) q.push({p->right, d + 1});\n}\n// 只有一个孩子时必须沿非空孩子走，不能把空子树当叶子；O(n) 时间", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("013  二叉树的镜像", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  在每个节点交换左右指针，再递归处理交换后的两个子树，所有节点各访问一次，时间 O(n)、空间 O(h)。迭代实现可把节点压入栈/队列并逐个交换，额外空间取决于树宽或深度。原树若仍被其他引用共享，原地修改会同时改变这些引用看到的结构。 该操作会修改原树；需要保留输入时应先深拷贝或构造新树。", size: 9.5pt)
  #raw("// 交换左右孩子后递归，原地镜像会修改输入树。\nNode* invert(Node* p) { if (!p) return nullptr;\n    std::swap(p->left, p->right); // 先交换，再递归处理两侧\n    invert(p->left); invert(p->right); return p;\n}\n// 每个节点访问一次，O(n) 时间、O(h) 递归栈；原地修改，需保留原树时先深拷贝\n// 极深树可换显式栈，避免递归栈深度受限", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("014  从前序和中序遍历构造二叉树", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  前序首元素是根，在中序中找到根的位置即可确定左子树长度，再切分前序剩余部分递归构造左右子树。用哈希表保存中序值到下标，可将总时间降为 O(n)、空间 O(n)。通常要求节点值唯一；有重复值时遍历序列可能无法唯一确定原树。 递归参数使用左右边界能避免子数组切片带来的额外复制成本。 建树前应校验两种遍历长度相同且元素集合一致，避免非法输入越界。", size: 9.5pt)
  #raw("// 前序当前首项给根，中序根位置给左子树长度。\n// pos[value] 为中序下标；唯一值，区间均为左闭右开\nNode* build(int pl, int il, int ir) { if (il == ir) return nullptr;\n    int root = pre[pl], k = pos[root], leftSize = k - il;\n    Node* left = build(pl + 1, il, k);\n    Node* right = build(pl + 1 + leftSize, k + 1, ir);\n    return new Node(root, left, right);\n}\n// 预建哈希表后 O(n) 时间、O(n) 空间；先校验两遍历元素一致", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("015  从后序和中序遍历构造二叉树", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  后序末元素是根，在中序中找到该值后，左侧为左子树，右侧为右子树；按左右子树大小从后序序列切片递归构造。用下标范围而非频繁复制子数组，并用哈希表定位中序位置，可达 O(n) 时间和 O(n) 辅助空间。节点值需唯一才能直接确定分割位置。 也可倒序消费后序数组，先构造根和右子树，再构造左子树。 递归切分时后序区间的根在最后，子树长度仍由中序中的分界位置确定。", size: 9.5pt)
  #raw("// 后序当前末项给根，中序根位置分割左右子树。\n// pos[value] 为中序下标；后序末项为根，节点值唯一\nNode* build(int pl, int pr, int il, int ir) { if (il == ir) return nullptr;\n    int root = post[pr - 1], k = pos[root], leftSize = k - il;\n    Node* left = build(pl, pl + leftSize, il, k);\n    Node* right = build(pl + leftSize, pr - 1, k + 1, ir);\n    return new Node(root, left, right);\n}\n// 用区间避免复制子数组；哈希定位后 O(n) 时间、O(n) 空间", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("13.3 排序、查找与有序结构", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("016  冒泡排序（Bubble Sort）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  每轮从左到右比较相邻元素，将逆序对交换，最大元素逐步冒到未排序区间末尾；某一轮无交换时可提前结束。排序稳定且原地，最好 O(n)，平均和最坏 O(n²)。它适合解释排序思想或很小的数据量，不适合大数组。 对逆序数组每轮都会发生大量交换，数据规模稍大时应换高效排序。 若输入几乎有序，提前停止标志会让算法接近一次扫描完成。", size: 9.5pt)
  #raw("// 每轮把最大值沉到未排序区末端，无交换表示已有序。\nfor (int end = n - 1; end > 0; --end) { bool changed = false;\n    for (int i = 0; i < end; ++i) if (a[i] > a[i + 1]) { std::swap(a[i], a[i + 1]); changed = true; }\n    if (!changed) break; // 已有序时提前结束\n}\n// 相等元素不交换所以稳定；原地，最好 O(n)，平均/最坏 O(n²)", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("017  判断一个二叉树是否为二叉搜索树（BST）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  递归检查每个节点是否落在祖先给出的合法开闭区间内，左子树上界收紧为当前值，右子树下界收紧为当前值。这样可发现仅比较父子节点会漏掉的远端违例。时间 O(n)、空间 O(h)；重复键是否允许需明确采用严格还是非严格边界。 中序遍历也能检验结果是否严格递增，但处理极值边界时区间法更直接。 允许重复键时，重复值必须始终被分配到约定的一侧并贯穿所有递归边界。", size: 9.5pt)
  #raw("// 祖先上下界同时约束节点，检查远端子树是否越界。\nbool valid(Node* p, long long low, long long high) {\n    if (!p) return true;\n    if (p->value <= low || p->value >= high) return false; // 严格 BST 边界\n    return valid(p->left, low, p->value) && valid(p->right, p->value, high);\n}\nbool isBst = valid(root, std::numeric_limits<long long>::lowest(), std::numeric_limits<long long>::max());\n// 若允许重复键，需按约定改开闭边界；O(n) 时间、O(h) 栈", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("018  判断一个二叉树是否是平衡二叉树", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  后序遍历一次计算子树高度，若任一子树已不平衡或左右高度差超过 1，就返回特殊值（如 -1）向上传播。该方法每个节点处理一次，时间 O(n)、栈空间 O(h)；逐节点重新计算高度会在偏斜树上退化到 O(n²)。空树通常视为平衡。 返回高度而非只返回真假，能把“是否平衡”和高度计算合并为一次遍历。 平衡判断的高度差是每个节点的局部约束，仅比较整树左右高度不够。", size: 9.5pt)
  #raw("// 后序返回高度，-1 作为失衡哨兵向上短路。\nint heightOrBad(Node* p) { if (!p) return 0;\n    int left = heightOrBad(p->left); if (left < 0) return -1;\n    int right = heightOrBad(p->right); if (right < 0) return -1;\n    if (std::abs(left - right) > 1) return -1; // -1 表示子树已失衡\n    return 1 + std::max(left, right);\n}\nbool balanced = heightOrBad(root) >= 0;\n// 后序一次算高度，O(n) 时间、O(h) 栈；空树平衡", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("019  反转单链表的核心指针操作是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  用 prev 保存前驱、cur 遍历当前节点，先保存 cur->next，再把 cur->next 指向 prev，最后推进两指针。循环结束后 prev 是新头节点，不能在改指针前丢失原后继。时间 O(n)、额外空间 O(1)，虚拟头结点不是必须的。 若要保留原链表，可新建节点复制；这会把额外空间增至 O(n)。", size: 9.5pt)
  #raw("// 反转前保存 next，避免改写链接后丢掉未处理后缀。\nNode* previous = nullptr; Node* current = head;\nwhile (current) {\n    Node* next = current->next; // 改链前先保存后继\n    current->next = previous; previous = current; current = next;\n}\nhead = previous; // 原尾成为新头\n// 原地 O(n) 时间、O(1) 额外空间；空链表也返回 nullptr", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("020  和为 K 的子数组个数如何计算？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  遍历数组维护前缀和 p；以当前位置为终点的和为 K 的子数组数量，等于之前出现过 p-K 的前缀和频次。先令频次表中 0 出现一次以涵盖从下标 0 开始的区间，然后计答案、再记录当前 p。平均 O(n) 时间、O(n) 空间，前缀和及答案都可能需要 64 位。 该方法适用于包含负数的数组，滑动窗口在负数场景通常不成立。", size: 9.5pt)
  #raw("// prefix-k 的旧频次就是以当前位置结尾的合法子数组数。\nstd::unordered_map<long long, long long> seen{{0, 1}};\nlong long prefix = 0, count = 0;\nfor (int x : a) { prefix += x;\n    count += seen[prefix - k]; // 先查旧前缀，涵盖负数与从下标 0 开始的段\n    ++seen[prefix];\n}\nreturn count; // 平均 O(n) 时间、O(n) 空间；和与答案使用 64 位", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("021  图中的环检测（Cycle Detection）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  无向图 DFS 时，遇到已访问且不是当前节点父边的邻点即有环；多重图需按边 ID 区分父边，否则平行边可能漏判。对有向图用白/灰/黑三色，访问到灰色节点表示回边和环。时间 O(V+E)，要遍历所有分量，不能只从一个起点检查。 无向图自环也是长度为一的环，简单图与多重图的边定义要统一。 DFS 颜色状态能在线性时间检测有向环，若只要拓扑序也可复用该结果。", size: 9.5pt)
  #raw("// 有向图灰色回边与无向图非父返边的判环条件不同。\n// 有向图看灰色回边；无向图忽略父边，平行边用 edgeId 区分。\nbool directedCycle(int u) { state[u] = 1;\n    for (int v : graph[u]) if (state[v] == 1 || (state[v] == 0 && directedCycle(v))) return true;\n    state[u] = 2; return false; }\nbool undirectedCycle(int u, int parentEdge) { seen[u] = true;\n    for (auto [v, edgeId] : graph[u]) if (edgeId != parentEdge && (seen[v] || undirectedCycle(v, edgeId))) return true;\n    return false; }\nbool hasCycle(bool directed) {\n    if (directed) { for (int u = 0; u < n; ++u) if (state[u] == 0 && directedCycle(u)) return true; return false; }\n    std::fill(seen.begin(), seen.end(), false);\n    for (int u = 0; u < n; ++u) if (!seen[u] && undirectedCycle(u, -1)) return true;\n    return false;\n} // 遍历全部连通分量，邻接表 O(V+E)", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("022  图的广度优先搜索（BFS）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  BFS 将起点入队并按层弹出，每发现未访问邻居就标记后入队，标记应在入队时做以免重复排队。无权图中首次发现节点的路径边数最少，因此可同时保存 parent 重建路径。邻接表实现时间 O(V+E)、空间 O(V)，边权非一致时不能直接用 BFS 求最短路。 保存每个节点首次入队的父节点，可按逆序回溯出一条最短路径。", size: 9.5pt)
  #raw("// 首次入队即固定无权最短距离，并可记录 parent 重建路径。\nstd::queue<int> q; distance[start] = 0; q.push(start);\nwhile (!q.empty()) { int u = q.front(); q.pop(); order.push_back(u);\n    for (int v : graph[u]) if (distance[v] == -1) {\n        distance[v] = distance[u] + 1; parent[v] = u; q.push(v); // 入队即标记\n    }\n}\n// 无权图首次发现即为最少边数；邻接表 O(V+E)，带权图不适用", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("023  图的强连通分量（Strongly Connected Components）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Kosaraju 第一次 DFS 记录节点完成时间顺序，再反转所有边，并按完成时间从大到小在反图做 DFS；每次新遍历得到一个强连通分量。每个节点和边被扫描有限次，时间 O(V+E)，需要保存反图和访问状态，空间 O(V+E)。大图递归 DFS 可能栈溢出，可改显式栈或用 Tarjan。 有向图反转边不会改变强连通分量集合，但决定第二次 DFS 的搜索方向。", size: 9.5pt)
  #raw("// 第一遍完成次序决定第二遍在反图搜索的 SCC 边界。\nvoid finishDfs(int u) { seen[u] = true; for (int v : graph[u]) if (!seen[v]) finishDfs(v); order.push_back(u); }\nvoid collect(int u) { seen[u] = true; component.push_back(u); for (int v : reverseGraph[u]) if (!seen[v]) collect(v); }\nfor (int u = 0; u < n; ++u) if (!seen[u]) finishDfs(u);\nstd::fill(seen.begin(), seen.end(), false);\nfor (auto it = order.rbegin(); it != order.rend(); ++it) if (!seen[*it]) {\n    component.clear(); collect(*it); groups.push_back(component);\n}\n// 反图保存边方向反转；总 O(V+E) 时间、O(V+E) 空间", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("024  图的深度优先搜索（DFS）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  从未访问节点开始沿邻边深入，递归返回时回溯；visited 必须在递归前标记，避免环导致无限访问。递归写法简洁，显式栈则适合避免深图调用栈限制；两者时间 O(V+E)、空间 O(V)。若图不连通，外层仍需依次启动未访问节点。 有向图若要识别回边，需用三色状态区分“已完成”和“当前路径”。 无向图遍历还需忽略已访问的父边，否则会把树边误判为环。", size: 9.5pt)
  #raw("// visited 必须在递归前设置，并从未访问节点覆盖所有分量。\nvoid dfs(int u) { seen[u] = true; order.push_back(u); // 首次发现即标记，防止环中重复递归\n    for (int v : graph[u]) if (!seen[v]) dfs(v);\n}\nfor (int u = 0; u < n; ++u) if (!seen[u]) dfs(u); // 覆盖非连通分量\n// 邻接表 O(V+E) 时间、O(V) 访问标记；递归深度最坏 O(V)", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("025  图的连通性检测", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  无向图从任意顶点做 BFS/DFS，访问数等于顶点数则连通；邻接表下时间 O(V+E)。空图是否视为连通要按题意定义，单点图通常连通。若题目要求有向图强连通，单次从一个点可达全体并不足够，应使用 Kosaraju、Tarjan 或等价判定。 邻接表扫描全部连通分量仍是 O(V+E)，不会重复处理每条边很多次。", size: 9.5pt)
  #raw("// 连通性由从起点可达的节点数与顶点总数比较。\nif (n == 0) return true; // 空图是否连通按题意定义\nstd::queue<int> q; seen[0] = true; q.push(0);\nwhile (!q.empty()) { int u = q.front(); q.pop();\n    for (int v : graph[u]) if (!seen[v]) { seen[v] = true; q.push(v); }\n}\nbool connected = std::all_of(seen.begin(), seen.end(), [](bool x) { return x; });\n// 无向图邻接表 O(V+E)；有向图强连通不能只做一次可达遍历", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("026  在旋转排序数组中查找元素", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  每轮判断中点左侧还是右侧包含旋转断点，再检查目标是否落在有序半区，保留可能区间。无重复元素时每轮缩半，时间 O(log n)、空间 O(1)；有重复值会让端点与中点相等而无法判断，此时需收缩边界，最坏 O(n)。边界比较要避免遗漏端点。 若只要任意命中值，可在找到目标时立即结束，不必继续找边界。 推荐维护闭区间时用 while (left <= right)，并统一以 mid±1 收缩。", size: 9.5pt)
  #raw("// 每轮先识别一侧有序区间，只保留目标可能所在半区。\nint left = 0, right = static_cast<int>(a.size()) - 1;\nwhile (left <= right) { int mid = left + (right - left) / 2;\n    if (a[mid] == target) return mid;\n    if (a[left] <= a[mid]) { if (a[left] <= target && target < a[mid]) right = mid - 1; else left = mid + 1; }\n    else { if (a[mid] < target && target <= a[right]) left = mid + 1; else right = mid - 1; }\n}\nreturn -1; // 无重复时 O(log n)；有重复且端点相等需收缩，最坏 O(n)", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("027  基数排序（Radix Sort）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  基数排序按数字位或字符位多轮排序，每轮使用稳定排序，低位优先时才能保留较低位次序。若每位用计数排序，时间 O(d(n+k))，空间 O(n+k)，d 为位数、k 为每位值域。负数需做符号映射或分开处理，不能直接假定所有整数都是非负定长。 字符串键可逐字符做基数排序，但排序方向和字符编码顺序须先定义。", size: 9.5pt)
  #raw("// 低位到高位逐位稳定排序，稳定性传递低位顺序。\n// 假设键均为非负整数；每一位必须稳定排序\nstd::vector<int> out(a.size());\nfor (long long exp = 1; maxValue / exp > 0; exp *= 10) {\n    std::array<int, 10> count{}; for (int x : a) ++count[(x / exp) % 10];\n    for (int d = 1; d < 10; ++d) count[d] += count[d - 1];\n    for (auto it = a.rbegin(); it != a.rend(); ++it) out[--count[(*it / exp) % 10]] = *it;\n    std::swap(a, out); // exp 从低位到高位，稳定性保留低位次序\n}\n// d 位、基数 10：O(d(n+10)) 时间、O(n+10) 空间；负数需另处理", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("028  堆排序（Heap Sort）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先将数组建成大顶堆，再反复交换堆顶最大值与当前末尾，缩小堆范围并向下调整根节点。建堆可在线性 O(n) 完成，整体 O(n log n)，原地且不稳定。若要升序输出使用大顶堆；处理空数组和单元素无需特殊搬移。 堆顶和末尾交换后只需向下调整根，因为左右子堆仍满足堆性质。 每次下滤时选择较大的孩子与父节点比较，直到局部堆序恢复。", size: 9.5pt)
  #raw("// 大顶堆根是当前最大值，交换后缩小有效堆区间。\nvoid siftDown(std::vector<int>& a, int root, int size) {\n    while (2 * root + 1 < size) { int child = 2 * root + 1;\n        if (child + 1 < size && a[child] < a[child + 1]) ++child;\n        if (a[root] >= a[child]) break; std::swap(a[root], a[child]); root = child;\n    }\n}\nfor (int i = n / 2 - 1; i >= 0; --i) siftDown(a, i, n); // O(n) 建大顶堆\nfor (int end = n - 1; end > 0; --end) { std::swap(a[0], a[end]); siftDown(a, 0, end); }\n// 原地升序、O(n log n)，不稳定；每轮只需修复根", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("029  如何使用 C++ 实现二分查找树？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  BST 查找时比较当前键并选择左右子树，插入在对应空位置建立节点；删除要区分叶节点、单孩子和双孩子，可用后继/前驱替换。操作复杂度 O(h)，未平衡时 h 可达 n；需要有界复杂度优先用 std::map 等平衡容器。自写实现还要定义重复键策略和节点内存所有权。 搜索递归版易实现，但深度退化树会造成栈深和性能问题。", size: 9.5pt)
  #raw("// BST 每一步按键比较收缩到一条搜索路径；高度未必平衡。\nNode* find(Node* p, int key) { while (p && p->key != key) p = key < p->key ? p->left : p->right; return p; }\nNode* insert(Node* p, int key) { if (!p) return new Node{key};\n    if (key < p->key) p->left = insert(p->left, key); else if (key > p->key) p->right = insert(p->right, key);\n    return p; // 重复键按策略忽略\n}\nNode* erase(Node* p, int key) { if (!p) return nullptr;\n    if (key < p->key) p->left = erase(p->left, key); else if (key > p->key) p->right = erase(p->right, key);\n    else if (!p->left || !p->right) { Node* child = p->left ? p->left : p->right; delete p; return child; }\n    else { Node* s = p->right; while (s->left) s = s->left; p->key = s->key; p->right = erase(p->right, s->key); }\n    return p;\n}\n// 查找/插入/删除 O(h)，双子树删除用右子树最小后继；需明确内存释放策略", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("030  如何使用 STL 实现有序容器？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  set/map 保存唯一键，multiset/multimap 允许重复键；关联容器按比较器维持顺序，便于 lower_bound、范围查询和有序遍历。查找、插入、删除通常 O(log n)，不保证连续存储。自定义键要提供满足严格弱序的比较器，否则容器行为不符合预期。 需要按插入顺序遍历时应选 unordered 容器之外的顺序容器，map 也不保插入序。", size: 9.5pt)
  #raw("// 按比较器顺序组织键，std::set/std::map 与 multi 版本决定重复键行为。\nstd::set<int> ordered{4, 1, 3}; ordered.insert(2);\nauto firstAtLeast = ordered.lower_bound(3); // 有序范围查询 O(log n)\nstd::map<std::string, int> score; score[\"Ada\"] = 10;\nfor (const auto& [name, value] : score) consume(name, value); // 按键排序遍历\nstd::multiset<int> allowDuplicates; allowDuplicates.insert(5); allowDuplicates.insert(5);\n// std::set/std::map 键唯一，multi 版本允许重复；查找插入删除 O(log n)，非连续存储", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("031  如何使用 std::map 和 std::unordered_map？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  std::map 按比较器有序，查找、插入和删除 O(log n)，支持范围查询；std::unordered_map 按哈希分桶，平均 O(1)，冲突严重时最坏 O(n)，遍历顺序不稳定。unordered_map 扩容会使迭代器失效，引用/指针规则不同于迭代器。按是否需要排序、稳定复杂度和可哈希键选择。", size: 9.5pt)
  #raw("// 是否需要范围有序遍历决定 std::map 与 std::unordered_map 的选择。\nstd::map<std::string, int> ordered; ordered[\"key\"] = 1;\nif (auto it = ordered.find(\"key\"); it != ordered.end()) use(it->second); // 有序，O(log n)\nstd::unordered_map<std::string, int> hashed; ++hashed[\"key\"];\nauto found = hashed.find(\"missing\"); if (found == hashed.end()) handleMissing();\n// 哈希表平均 O(1)、最坏 O(n)，遍历顺序不稳定；std::map 支持范围查询\n// std::unordered_map 扩容会使迭代器失效，选择取决于顺序和复杂度要求", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("032  如何使用 std::vector 和 std::array？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  vector<T> 运行时长度可变，元素连续，适合动态数组和传给要求连续内存的接口；扩容会分配新存储并移动元素。array<T,N> 长度 N 编译期固定，通常直接内嵌存储且没有动态分配。二者随机访问 O(1)，都提供连续元素；还需考虑对象大小、生命周期和是否允许调整长度。 array 的 N 可为零；vector 还可显式 reserve 预留容量以减少扩容次数。", size: 9.5pt)
  #raw("// std::vector 长度可变、std::array 长度编译期固定，两者元素连续。\nstd::vector<int> dynamic; dynamic.reserve(100); dynamic.push_back(7); // 运行期可变且连续\nstd::array<int, 3> fixed{{1, 2, 3}}; // 长度编译期固定，也连续\nint first = dynamic[0], second = fixed.at(1); // 随机访问 O(1)\n// std::vector 扩容可能搬迁元素；reserve 可减少扩容次数\n// std::array 不动态分配长度；二者都可提供连续元素数据", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("13.4 链表、字符串与基础数据结构", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("033  如何删除链表倒数第 N 个节点？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  设置虚拟头节点，快指针先从 dummy 向前走 n 步，再让快慢指针一起走到快指针到尾部；此时慢指针后继就是待删节点。删除后继并返回 dummy.next，统一处理删除原头节点。时间 O(n)、空间 O(1)，先验证 n 在链表长度范围内可避免空指针。", size: 9.5pt)
  #raw("// 快慢指针保持 n 个节点距离，慢指针停在待删节点前。\nif (n <= 0) return head; // 非法 n 按接口约定处理\nNode dummy{0, head}; Node* fast = &dummy; Node* slow = &dummy;\nfor (int i = 0; i < n && fast; ++i) fast = fast->next;\nif (!fast) return head; // n 大于链表长度时不删除\nwhile (fast->next) { fast = fast->next; slow = slow->next; }\nslow->next = slow->next->next; return dummy.next;\n// 单趟 O(n) 时间、O(1) 空间；dummy 统一覆盖删除头节点", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("034  如何判断一个字符串是回文？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  左右指针分别从字符串两端向中间移动，按题目规则跳过标点或空格后比较对应字符，不等即可判非回文。忽略大小写时先统一大小写或按规则比较，时间 O(n)、额外空间 O(1)。C++ 的 std::string 按字节存储，若输入为 UTF-8 且需按 Unicode 字符判断，必须先解码。 若比较的字节包含组合字符，视觉上相同的文本也可能有不同编码序列。", size: 9.5pt)
  #raw("// 左右端字符按题目规范化后逐对比较，跳过规则需一致。\nbool palindrome(const std::string& s) { int left = 0, right = static_cast<int>(s.size()) - 1;\n    while (left < right) {\n        while (left < right && ignored(s[left])) ++left; // 若题目忽略标点则跳过\n        while (left < right && ignored(s[right])) --right;\n        if (lower(s[left++]) != lower(s[right--])) return false;\n    }\n    return true;\n}\n// O(n) 时间、O(1) 额外空间；UTF-8 应先按 Unicode 字符解码", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("035  如何判断两个链表是否相交？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  链表相交指节点地址相同，而不是节点值相同；分别遍历到尾部后，令指针切换到另一条链表头，最终会在交点或同时到空处相遇。时间 O(m+n)、空间 O(1)，无需预先求长度，空链表也自然适用。若题意是值相同，则那是不同问题。 两链表长度差由“换头后走完两段”自动抵消，无需额外长度计算。 交点之后两条链表共享同一后缀，所以尾节点地址不同可以先排除相交。", size: 9.5pt)
  #raw("// 换到另一链表后抵消两表长度差，按节点地址判断交点。\nNode* a = headA; Node* b = headB;\nwhile (a != b) { a = a ? a->next : headB; b = b ? b->next : headA; }\nreturn a; // 同时到 nullptr 表示不相交\n// 相交按节点地址相同判定，不是值相等；换头抵消长度差\n// O(m+n) 时间、O(1) 空间，空链表自然返回 nullptr", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("036  如何判断二叉树是否对称？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  递归比较一对镜像节点：二者同时为空才匹配，只有一边为空或值不同则失败；继续比较左节点的左孩子与右节点的右孩子，以及相反方向。时间 O(n)、递归栈 O(h)，也可把节点对压入队列迭代。空树通常对称，重复值不会影响结构判断。 用节点值相等不够，还必须比较两侧结构是否按镜像方向对应。 迭代法每次把两个待比较子树成对入队，能避免极深树的递归风险。", size: 9.5pt)
  #raw("// 每次比较一对镜像位置，结构和节点值都必须对应。\nbool mirror(Node* a, Node* b) {\n    if (!a || !b) return a == b; // 必须同时为空\n    return a->value == b->value && mirror(a->left, b->right) && mirror(a->right, b->left);\n}\nbool symmetric = !root || mirror(root->left, root->right);\n// 同时比较值与镜像结构；每节点至多访问一次，O(n) 时间、O(h) 栈", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("037  如何判断链表是否有环并找到入环点？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  快慢指针从头出发，慢走一步、快走两步；若相遇则有环，若快指针或其 next 为空则无环。相遇后把一个指针放回头节点，两者每次各走一步，第二次相遇点是环入口。证明依赖相遇时两者在环上的距离关系；时间 O(n)、空间 O(1)。 若只判断有无环，可在首次快慢相遇时返回，不需要第二阶段。 有环时快慢指针必相遇，因为相对速度为每轮一个环内节点。", size: 9.5pt)
  #raw("// 首次相遇用于确认有环，第二阶段交点才是入环位置。\nNode* slow = head; Node* fast = head;\ndo { if (!fast || !fast->next) return nullptr; slow = slow->next; fast = fast->next->next; } while (slow != fast);\nNode* fromHead = head;\nwhile (fromHead != slow) { fromHead = fromHead->next; slow = slow->next; }\nreturn fromHead; // 两指针再次相遇即环入口\n// 有环时快慢必相遇；时间 O(n)、额外空间 O(1)", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("038  如何原地合并两个有序数组？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  第一个数组预留了 m+n 个位置时，从两数组有效区间尾部比较，将较大值写入第一个数组末尾并向前移动。尾部填充不会覆盖尚未比较的数据；当第二数组耗尽时第一个数组剩余内容已在正确位置。时间 O(m+n)、额外空间 O(1)，前提是第一个数组容量足够。 尾部写入过程中若第一数组已无有效元素，直接复制第二数组剩余部分。", size: 9.5pt)
  #raw("// 从尾部写入避免覆盖 a 尚未处理的前缀。\nint i = m - 1, j = n - 1, write = m + n - 1;\nwhile (j >= 0) { // 从后向前写，不覆盖 a 中尚未读取的有效元素\n    if (i >= 0 && a[i] > b[j]) a[write--] = a[i--];\n    else a[write--] = b[j--];\n}\n// b 用尽时 a 剩余前缀原位有序；O(m+n) 时间、O(1) 额外空间", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("039  如何合并两个有序链表？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  用虚拟头节点逐次比较两个链表当前值，把较小节点接到结果尾部并推进对应指针；一方耗尽后直接接上另一方剩余部分。复用原节点时额外空间 O(1)、时间 O(m+n)，相等时固定优先取左侧可保持稳定次序。若不能修改输入节点，则需分配新节点。 迭代时每轮至少消耗一个节点，保证链表长度有限时算法终止。 合并完成后结果总节点数为 m+n，不应额外复制或重复链接已消费节点。", size: 9.5pt)
  #raw("// 每次摘取较小头节点，尾指针始终指向结果末端。\nNode dummy{}; Node* tail = &dummy;\nwhile (a && b) { Node*& pick = a->value <= b->value ? a : b;\n    tail->next = pick; pick = pick->next; tail = tail->next; // 复用节点，左侧优先保持稳定\n}\ntail->next = a ? a : b; return dummy.next;\n// 一方耗尽后直接接剩余链；O(m+n) 时间、O(1) 额外空间", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("040  如何合并重叠区间？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先按左端点排序，遍历时维护当前合并区间；下一段与当前段重叠或相接时扩展右边界，否则输出当前段并开始新区间。相接是否算重叠取决于端点是闭区间还是开区间。排序耗时 O(n log n)，额外空间视排序实现和输出是否计入而定。 例如闭区间 [1,3] 与 [3,5] 是否合并，取决于题目是否把端点相接算重叠。", size: 9.5pt)
  #raw("// 已排序区间只需比较当前新区间与结果末尾的右边界。\nstd::sort(intervals.begin(), intervals.end(), [](const auto& a, const auto& b) { return a.start < b.start; });\nstd::vector<Interval> merged;\nfor (const auto& x : intervals) {\n    if (merged.empty() || merged.back().end < x.start) merged.push_back(x);\n    else merged.back().end = std::max(merged.back().end, x.end); // 合并闭区间重叠/相接\n}\n// 空输入返回空结果；排序 O(n log n)，扫描 O(n)\n// 开区间是否合并端点相接要按题意调整比较符", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("041  如何在 C++ 中实现并查集？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  初始化每个元素的父节点为自身，find 沿父指针找代表元并做路径压缩；union 比较代表元，再按秩或集合大小挂接较小树。路径压缩和按秩合并结合后，m 次操作摊还 O(mα(n))，可高效维护只增不删的连通关系。删除边或动态连通性需要其他数据结构。 并查集只支持合并而不支持高效拆分，不能直接用于任意删除关系。", size: 9.5pt)
  #raw("// 代表元标识集合；路径压缩与按大小合并控制树高。\nint find(int x) { return parent[x] == x ? x : parent[x] = find(parent[x]); } // 路径压缩\nbool unite(int a, int b) { a = find(a); b = find(b); if (a == b) return false;\n    if (size[a] < size[b]) std::swap(a, b); // 小树挂大树\n    parent[b] = a; size[a] += size[b]; return true;\n}\n// 初始化 parent[i]=i、size[i]=1；合并+压缩摊还 O(α(n))\n// 适合只合并不拆分的动态连通关系", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("042  如何实现 KMP 算法？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  KMP 先计算模式串每个前缀的最长相等真前后缀长度；文本失配时将模式位置回退到该长度，而文本指针不回退。这样利用已匹配信息避免重复比较，预处理 O(m)、扫描 O(n)，总计 O(n+m)。空模式和字符比较规则需按接口定义处理。 前缀数组的定义有多种写法，构造和失配回退必须保持同一套下标约定。 面试中可以手算模式串 `ababaca` 的前缀表，解释失配时为何不回退文本指针。", size: 9.5pt)
  #raw("// pi 记录可复用的前缀长度，失配时文本下标不回退。\n// pi[i] 是 pattern[0..i] 的最长相等真前后缀长度\nif (pattern.empty()) return {0}; // 若接口要求所有边界位置，在此改为返回 0..text.size()\nstd::vector<int> pi(pattern.size());\nfor (int i = 1, j = 0; i < pattern.size(); ++i) {\n    while (j && pattern[i] != pattern[j]) j = pi[j - 1];\n    if (pattern[i] == pattern[j]) ++j; pi[i] = j;\n}\nfor (int i = 0, j = 0; i < text.size(); ++i) {\n    while (j && text[i] != pattern[j]) j = pi[j - 1];\n    if (text[i] == pattern[j]) ++j;\n    if (j == pattern.size()) { matches.push_back(i - j + 1); j = pi[j - 1]; }\n}\n// 空模式需单独定义；预处理 O(m)、扫描 O(n)，文本指针不回退", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("043  如何实现一个链表？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  单链表节点通常含值和 next，双链表再含 prev；插入删除要分别处理头、尾、空表和单节点边界。查找节点 O(n)，已知节点位置改指针可 O(1)，但拥有节点的代码必须负责释放且避免重复释放。现代 C++ 一般优先用 std::list 或容器，只有明确需要自定义链式结构时才手动管理。 C++ 可用 unique_ptr 表达单向所有权，避免手写析构遗漏节点。", size: 9.5pt)
  #raw("// head 独占整条单链表，移动 std::unique_ptr 转移所有权。\nstruct Node { int value; std::unique_ptr<Node> next; };\nstd::unique_ptr<Node> head;\nvoid pushFront(int x) { auto node = std::make_unique<Node>(); node->value = x;\n    node->next = std::move(head); head = std::move(node);\n}\nvoid popFront() { if (head) head = std::move(head->next); }\n// 单链表头插/头删 O(1)，std::unique_ptr 自动释放整条所有权链\n// 查找仍为 O(n)；双链表还需维护 prev 与头尾边界", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("044  如何实现动态规划？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先把状态定义成能回答目标的量，例如 dp[i] 表示前 i 个元素的最优值，再从最后一步推导转移与边界。依据依赖关系确定循环顺序，滚动数组压缩空间前要确认旧状态不会再被需要。最后用小输入手算，并检查每个合法方案是否都被状态转移覆盖。 例如零钱兑换按金额递增计算，而 0/1 背包按容量递减以限制物品使用次数。", size: 9.5pt)
  #raw("// dp[x] 代表金额 x 的最优值，状态按依赖从小到大计算。\n// dp[x]：组成金额 x 所需的最少硬币数；硬币面值必须为正\nconst int inf = amount + 1; std::vector<int> dp(amount + 1, inf); dp[0] = 0;\nfor (int x = 1; x <= amount; ++x) for (int coin : coins) {\n    if (coin <= x && dp[x - coin] != inf) dp[x] = std::min(dp[x], dp[x - coin] + 1);\n}\nreturn dp[amount] == inf ? -1 : dp[amount];\n// 先定义状态/边界，再按依赖从小到大计算；O(amount * coins) 时间", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("045  如何实现哈希表？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  哈希表用哈希函数将键映射到桶，碰撞时可用链地址或开放寻址继续查找；相等的键必须产生相同哈希值。负载因子过高时扩容重哈希，删除操作在开放寻址中需采用墓碑等策略避免搜索链断裂。平均查找 O(1)，恶意碰撞或不佳分布下可退化 O(n)。 自定义键还需同步实现相等比较与哈希函数，二者必须保持一致。 对开放寻址表，装载因子和探测序列共同影响聚簇与查找长度。", size: 9.5pt)
  #raw("// 桶下标由哈希函数决定，桶内相等比较解决碰撞。\n// 链地址法：哈希相同的键进入同桶，再用相等比较区分\nif (capacity == 0) capacity = 1; std::vector<std::vector<Entry>> buckets(capacity);\nauto bucket = [&](const Key& key) { return std::hash<Key>{}(key) % buckets.size(); };\nEntry* find(const Key& key) { for (Entry& e : buckets[bucket(key)]) if (equal(e.key, key)) return &e; return nullptr; }\nvoid insert(Key key, Value value) { auto& chain = buckets[bucket(key)];\n    for (Entry& e : chain) if (equal(e.key, key)) { e.value = value; return; }\n    chain.push_back({std::move(key), std::move(value)}); ++size;\n    if (static_cast<double>(size) / buckets.size() > maxLoad) rehash();\n}\n// rehash 需重算所有桶下标；开放寻址删除要用墓碑避免探测链断开\n// 平均查找 O(1)，恶意碰撞或不佳分布下可退化 O(n)", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("13.5 常见结构与搜索算法", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("046  如何实现图的DFS和BFS？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  邻接表保存每个顶点的邻居，DFS 用递归/显式栈深入，BFS 用队列逐层访问；两者均在首次发现时标记 visited。DFS 适合连通分量与回溯，BFS 在无权图中能求最少边数路径。遍历所有节点和边的时间 O(V+E)，递归深度可能达到 V。 无权最短路选 BFS；带权非负图应改用 Dijkstra 而不是 DFS。", size: 9.5pt)
  #raw("// DFS 深入回溯，BFS 按层扩展并在无权图求最短边数。\nvoid dfs(int u) { seen[u] = true; for (int v : graph[u]) if (!seen[v]) dfs(v); }\nfor (int u = 0; u < n; ++u) if (!seen[u]) dfs(u); // 覆盖所有分量\nstd::fill(seen.begin(), seen.end(), false); // 重新初始化后从 start 做 BFS\nstd::queue<int> q; seen[start] = true; distance[start] = 0; q.push(start);\nwhile (!q.empty()) { int u = q.front(); q.pop();\n    for (int v : graph[u]) if (!seen[v]) { seen[v] = true; distance[v] = distance[u] + 1; q.push(v); }\n}\n// 首次发现时标记；DFS 用于深入/回溯，BFS 求无权最少边数\n// 邻接表两者 O(V+E)；带权非负图用 Dijkstra", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("047  如何实现堆排序？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  大顶堆可用数组表示，子节点下标由父下标计算；从最后一个非叶节点开始向下调整可在线性时间建堆。之后将堆顶与末尾交换并缩小有效区间，逐步输出升序结果。总时间 O(n log n)、额外空间 O(1)，堆排序不稳定。 数组从零开始时左右子节点索引为 2*i+1 和 2*i+2。 自底向上 heapify 每个节点的工作量随层高递减，所以建堆不是 O(n log n)。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("048  如何实现快速排序和归并排序？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  快速排序选 pivot 分区后递归，平均 O(n log n)、最坏 O(n²)，通常原地且不稳定；随机 pivot 或三数取中可降低常见输入退化概率。归并排序递归拆半再合并，时间稳定 O(n log n)，数组实现通常需 O(n) 临时空间且稳定。选择时看内存限制、稳定性和最坏时间要求。 对重复 pivot 键，三路划分能把相等区间一次处理完，减少递归规模。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("049  如何实现栈和队列？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  栈按后进先出，用 vector/deque 支持 push、pop、top；队列按先进先出，用 deque 或固定数组环形缓冲区支持入队出队。动态容器常见端操作均摊 O(1)，环形队列需用计数或空槽规则区分满与空。多线程环境还需同步，普通容器本身不保证并发安全。 STL 的 std::stack 和 std::queue 是容器适配器，可用 deque 作为底层容器。", size: 9.5pt)
  #raw("// 栈操作尾端、队列操作两端，读取或弹出前要检查空状态。\nstd::stack<int> lifo; lifo.push(x); int top = lifo.top(); lifo.pop();\nstd::queue<int> fifo; fifo.push(x); int front = fifo.front(); fifo.pop();\n// 栈后进先出，队列先进先出；先检查 empty 再读 top/front 或 pop\n// std::stack/std::queue 是容器适配器，端操作通常 O(1)\n// 固定数组队列可用 head/tail 环绕，并用计数区分满和空", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("050  如何找到二叉树的最低公共祖先（LCA）？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  后序递归在目标节点命中时返回自身，空子树返回空；若左右结果都非空，当前节点就是最低公共祖先，否则返回那一侧的非空结果。时间 O(n)、空间 O(h)，适用于普通二叉树。若节点不存在时也要求返回空，需额外统计两目标是否均被找到；BST 可利用键值顺序优化。 若树是二叉搜索树，可比较两个目标值与根值并只递归一个子树。", size: 9.5pt)
  #raw("// 左右递归都返回目标时当前节点是分叉最低点。\nNode* lca(Node* p, Node* a, Node* b) { if (!p || p == a || p == b) return p;\n    Node* left = lca(p->left, a, b); Node* right = lca(p->right, a, b);\n    if (left && right) return p; // 两侧各找到一个，当前节点是最低公共祖先\n    return left ? left : right;\n}\n// 普通二叉树 O(n) 时间、O(h) 栈；若节点可能不存在需另计数确认两者均找到", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("051  如何求二叉树右视图？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  层序遍历时记录每层最后弹出的节点，即为从右侧看到的值；也可 DFS 按右、左顺序先访问，并在首次到达某深度时记录节点。时间 O(n)，队列法空间 O(w)，DFS 栈 O(h)。树为空时结果为空，DFS 记录深度时要确保数组按层扩展。 若用 DFS，必须先访问右孩子再访问左孩子，才能保证同层首次出现的是最右节点。", size: 9.5pt)
  #raw("// 队列中固定的一层宽度内，最后一个弹出的节点是右视值。\nif (!root) return view;\nstd::queue<Node*> q; q.push(root);\nwhile (!q.empty()) { int width = q.size();\n    for (int i = 0; i < width; ++i) { Node* p = q.front(); q.pop();\n        if (i == width - 1) view.push_back(p->value); // 每层最后弹出者\n        if (p->left) q.push(p->left); if (p->right) q.push(p->right);\n    }\n}\n// O(n) 时间、队列 O(w) 空间；DFS 也可按右、左顺序首次记层", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("052  如何生成全排列或子集？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  回溯维护 path，在每个选择点尝试尚未使用的元素；全排列用 visited 或交换控制，子集则在每层先记录当前 path 再继续扩展。若输入有重复值，先排序并跳过“同层前一个相同且未使用”的元素。时间至少与输出总长度成正比，排列规模可达 n!，需要考虑结果内存。 若要求字典序输出，可在排序后按固定候选顺序扩展，并按输出规模估算内存。", size: 9.5pt)
  #raw("// path 是当前选择；回溯返回时必须撤销本层选择。\nvoid subsets(int start) { out.push_back(path); // 每个递归状态本身就是一个子集\n    for (int i = start; i < a.size(); ++i) {\n        if (i > start && a[i] == a[i - 1]) continue; // 排序后跳过同层重复值\n        path.push_back(a[i]); subsets(i + 1); path.pop_back();\n    }\n}\nvoid permutations() { if (path.size() == a.size()) { out.push_back(path); return; }\n    for (int i = 0; i < a.size(); ++i) if (!used[i]) {\n        if (i && a[i] == a[i - 1] && !used[i - 1]) continue;\n        used[i] = true; path.push_back(a[i]); permutations(); path.pop_back(); used[i] = false;\n    }\n}\n// 输入先排序以去重；输出规模可达 2^n 或 n!，结果可能占主要内存", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("053  如何用两个栈实现队列？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  入队时把元素压入输入栈；出队或查看队首时，只有输出栈为空才把输入栈全部弹出并压入输出栈，然后从输出栈顶取值。一次倒序转换后后续出队无需搬动，每个元素最多进出两个栈各一次，因此操作均摊 O(1)。若输出栈非空时新元素仍留在输入栈即可保持 FIFO。", size: 9.5pt)
  #raw("// 只有输出栈空才倒序搬运，之后其栈顶即队首。\nstd::stack<int> input, output;\nvoid push(int x) { input.push(x); } // 新元素暂放输入栈\nint front() { if (output.empty()) while (!input.empty()) { output.push(input.top()); input.pop(); }\n    if (output.empty()) throw EmptyQueue{}; return output.top();\n}\nvoid pop() { (void)front(); output.pop(); }\n// 仅当输出栈空才搬运，保持 FIFO；每元素搬运一次，均摊 O(1)", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("054  如何用单调栈求柱状图最大矩形？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  维护柱高递增的下标栈，遇到低于栈顶的高度就弹出；弹出柱子的右边界为当前下标，左边界为新栈顶之后一格，面积为高度乘宽度。末尾加入高度 0 的哨兵可统一结算所有柱子。时间 O(n)、空间 O(n)，相同高度的入栈/弹出规则要保持边界计算一致。 柱高含重复值时，统一用严格递增或非递减栈即可，但宽度边界需配套。", size: 9.5pt)
  #raw("// 单调栈保存尚未找到右侧更矮柱子的下标。\nfor (int i = 0; i <= heights.size(); ++i) { // i==n 视作高度 0 的哨兵\n    int current = i == heights.size() ? 0 : heights[i];\n    while (!st.empty() && heights[st.back()] > current) {\n        int h = heights[st.back()]; st.pop_back();\n        int left = st.empty() ? -1 : st.back();\n        best = std::max(best, h * (i - left - 1)); // 左右第一个更矮柱间的宽度\n    }\n    if (i < heights.size()) st.push_back(i);\n}\n// 每个下标入栈出栈一次，O(n) 时间、O(n) 空间；空输入答案 0", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("055  如何用哈希表解决数组查重和两数之和？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  查重时遍历并把已见值放入哈希集合，集合已有该值即可报告重复；两数之和则先查 target-x，再保存 x 与下标，确保不会把当前元素重复使用。平均时间 O(n)、空间 O(n)，若需返回所有索引或唯一数对，必须明确重复元素与答案去重规则。补数运算要考虑整数溢出。 若数组元素可重复，两数之和应在查找补数之后记录当前值，避免自配对。", size: 9.5pt)
  #raw("// 两数之和先查补数再登记当前值，避免元素自配对。\nstd::unordered_set<int> seen;\nfor (int x : a) if (!seen.insert(x).second) duplicates.push_back(x); // 查重\nstd::unordered_map<int, int> index;\nfor (int i = 0; i < a.size(); ++i) { auto it = index.find(target - a[i]);\n    if (it != index.end()) return std::pair<int, int>{it->second, i}; // 先查再存，避免自配对\n    index[a[i]] = i;\n}\n// 平均 O(n) 时间、O(n) 空间；补数运算也要防溢出", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("056  如何用队列实现栈？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  使用一个队列时，每次入栈先把新元素入队，再把队列前面的 n-1 个元素依次移到队尾，让新元素位于队首；出栈直接弹队首。这样 push O(n)、pop/top O(1)，队列只需保存元素。若采用双队列交换，可让入栈 O(1) 而出栈 O(n)，按操作频率选择。", size: 9.5pt)
  #raw("// 旋转旧队列元素到尾部，让新入队值位于队首模拟栈顶。\nstd::queue<int> q;\nvoid push(int x) { q.push(x); for (int i = 1; i < q.size(); ++i) { q.push(q.front()); q.pop(); } }\nint top() { return q.front(); }\nvoid pop() { q.pop(); }\n// 每次 push 后轮转旧元素，使新元素在队首：push O(n)，top/pop O(1)\n// 空栈操作前需检查；双队列可改为 push O(1)、pop O(n)", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("057  如何解决背包问题？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先明确每件物品能否重复、重量是否整数以及目标是最大价值还是方案数。0/1 背包容量倒序避免重复取当前物品，完全背包正序允许同一物品再次参与本轮转移；多重背包需拆分数量或用单调队列优化。基础动态规划时间 O(nW)、空间 O(W)，W 很大时要考虑值域或稀疏状态优化。 若返回具体选取方案而非最优值，空间压缩后还需保留决策或回溯记录。", size: 9.5pt)
  #raw("// 0/1 倒序阻止重复取用；完全背包正序允许本轮重用。\n// 0/1 背包：容量倒序，同件物品本轮不能再次使用\nfor (const auto& item : items) for (int c = W; c >= item.weight; --c)\n    dp[c] = std::max(dp[c], dp[c - item.weight] + item.value);\n// 完全背包：容量正序，让当前物品的本轮新状态继续参与转移\nfor (const auto& item : reusable) for (int c = item.weight; c <= W; ++c)\n    dp[c] = std::max(dp[c], dp[c - item.weight] + item.value);\n// 基础 O(nW) 时间、O(W) 空间；多重背包可二进制拆分数量", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("058  如何计算二叉树路径总和？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  根到叶是否存在目标和，可在 DFS 中传递剩余目标，只有到叶子且剩余值匹配才成功，负数节点也能正确处理。若统计任意起止向下路径数，用前缀和频次：当前累和 s 时累加此前 s-target 的次数，并在返回时回溯计数。需区分路径方向和起止范围，时间 O(n)、额外空间 O(h) 或路径前缀表。 回溯时移除当前前缀和计数，避免兄弟子树把彼此路径错误地组合。", size: 9.5pt)
  #raw("// remain 只在从根向下路径累减，且仅叶节点可结束路径。\nbool hasPath(Node* p, long long remain) { if (!p) return false;\n    remain -= p->value;\n    if (!p->left && !p->right) return remain == 0; // 只有叶子才能结束路径\n    return hasPath(p->left, remain) || hasPath(p->right, remain);\n}\n// 根到叶路径，负数也适用；O(n) 时间、O(h) 栈\n// 若统计任意向下路径，改用前缀和频次并在回溯时撤销计数", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("059  如何设计支持 O(1) push、pop、top 和 getMin 的最小栈？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  主栈保存元素，辅助栈在每次压入时记录当前最小值；弹出主栈时同步弹出辅助栈，getMin 即读辅助栈顶。相等最小值也应重复入栈，避免弹出一个后丢失剩余最小值；也可每项存值和当前最小值。操作 O(1)，额外空间 O(n)。 辅助栈若只在新值小于当前最小时入栈，弹出时需同步判断是否等于最小值。 对空栈调用 top、pop 或 getMin 应规定异常、断言或错误返回行为。", size: 9.5pt)
  #raw("// 每个栈项保存截至当前位置的最小值，弹出时自动恢复旧最小值。\nstd::stack<std::pair<int, int>> values; // 每项保存 (值, 到此为止的最小值)\nvoid push(int x) { int m = values.empty() ? x : std::min(x, values.top().second); values.emplace(x, m); }\nvoid pop() { if (!values.empty()) values.pop(); }\nint top() const { return values.top().first; }\nint getMin() const { return values.top().second; }\n// push/pop/top/getMin 均 O(1)，空间 O(n)；空栈行为需定义", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("060  将二叉树转换为链表（Flatten Binary Tree to Linked List）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  若不要求 O(1) 额外空间，可做逆前序递归（右、左、根），用 prev 将节点串成右链，时间 O(n)、调用栈 O(h)。若必须原地 O(1) 空间，沿树遍历：找到当前左子树最右节点，把原右子树接到其后，再将左子树移到右侧并清空 left。展开顺序应为根、左、右；不要把递归调用误称为常数空间。 迭代前序加显式栈也正确，但栈最坏 O(h)；常数空间版本需谨慎检查重连指针。", size: 9.5pt)
  #raw("// 把左子树移到右侧前，先把原右子树接到左子树最右端。\nNode* current = root;\nwhile (current) {\n    if (current->left) { Node* rightmost = current->left;\n        while (rightmost->right) rightmost = rightmost->right;\n        rightmost->right = current->right; // 接上原右子树\n        current->right = current->left; current->left = nullptr;\n    }\n    current = current->right;\n}\n// 原地前序展开，额外空间 O(1)、时间最坏 O(n²) 找右边界\n// 逆前序递归更简洁但需 O(h) 调用栈", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("061  岛屿数量问题（Number of Islands）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  逐格扫描网格，遇到未访问陆地就把岛屿数加一，并用 DFS/BFS 将上下左右相连的陆地标记为已访问。原地把 1 改成 0 可省 visited 数组，但若输入不可修改则需单独标记。每个格子至多处理一次，时间 O(MN)，最坏队列或递归栈 O(MN)；对角线是否连接按题目定义。 若递归实现的地图很大，BFS 或显式栈能避免调用栈深度受限。", size: 9.5pt)
  #raw("// 每片陆地首次发现就标记，避免相邻格重复扩展。\nvoid flood(int r, int c) { if (r < 0 || r == rows || c < 0 || c == cols || grid[r][c] != '1') return;\n    grid[r][c] = '0'; // 入栈/递归前标记，避免重复访问\n    flood(r + 1, c); flood(r - 1, c); flood(r, c + 1); flood(r, c - 1);\n}\nfor (int r = 0; r < rows; ++r) for (int c = 0; c < cols; ++c)\n    if (grid[r][c] == '1') { ++islands; flood(r, c); }\n// O(rows*cols) 时间、最坏 O(rows*cols) 栈/队列；输入不可改则另设 visited", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("13.6 排序、组合搜索与贪心", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("062  归并排序（Merge Sort）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  归并排序把区间拆成两半递归排序，再用双指针将两个有序子区间线性合并；相等时先取左侧元素可保持稳定性。每层总合并工作 O(n)，共 O(log n) 层，因此时间 O(n log n)，数组通常需 O(n) 临时空间。链表可通过拆链和合并做到较少额外存储，也适合外部排序。 每次分割都应尽量平衡；链表排序可用快慢指针拆分，避免随机访问。", size: 9.5pt)
  #raw("// 归并时相等元素优先取左半，保留稳定次序。\nvoid mergeSort(int left, int right) { if (right - left <= 1) return;\n    int mid = left + (right - left) / 2; mergeSort(left, mid); mergeSort(mid, right);\n    int i = left, j = mid; tmp.clear();\n    while (i < mid || j < right) tmp.push_back(j == right || (i < mid && a[i] <= a[j]) ? a[i++] : a[j++]);\n    std::copy(tmp.begin(), tmp.end(), a.begin() + left);\n}\n// 相等时先取左项保证稳定；O(n log n) 时间、数组临时空间 O(n)", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("063  快速排序（Quick Sort）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  选 pivot 后用双指针或 Lomuto/Hoare 分区把元素按大小放到两侧，再递归排序子区间。平均时间 O(n log n)，极端划分会退化 O(n²)；随机 pivot、三数取中或三路分区可降低有序输入和大量重复值的退化。原地版本空间通常为递归栈，且排序一般不稳定。 三路分区把小于、等于和大于 pivot 分开，重复键很多时效果更好。", size: 9.5pt)
  #raw("// 三路分区把等于 pivot 的中间段一次排定。\nvoid quickSort(int left, int right) { if (left >= right) return;\n    int pivot = a[left + (right - left) / 2], low = left, i = left, high = right;\n    while (i <= high) { if (a[i] < pivot) std::swap(a[low++], a[i++]);\n        else if (a[i] > pivot) std::swap(a[i], a[high--]); else ++i; }\n    quickSort(left, low - 1); quickSort(high + 1, right); // 中间等值段已完成\n}\n// 平均 O(n log n)，坏划分 O(n²)；三路划分利于大量重复值，排序不稳定", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("064  打家劫舍问题的状态转移是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  按 0 下标数组定义，可令 dp[i] 为考虑前 i 间房的最大收益，转移为 max(dp[i-1], dp[i-2]+nums[i-1])，并正确设置 i=0、1 的边界。只需滚动保存前两项，时间 O(n)、空间 O(1)。环形街区不能直接套此式，应分别排除首间或末间求最大值。 该递推默认相邻房屋不能同时选择，若可选房屋为空则收益为零。", size: 9.5pt)
  #raw("// prev1/prev2 分别表示前一间与前两间范围的最优收益。\nlong long prev2 = 0, prev1 = 0; // 前 0/1 间房的最优收益\nfor (int money : houses) { long long now = std::max(prev1, prev2 + money);\n    prev2 = prev1; prev1 = now; // 不抢当前 vs 抢当前\n}\nreturn prev1; // O(n) 时间、O(1) 空间；允许一间不抢故初值为 0\n// 环形街区需分别计算不含首间与不含末间两段再取最大", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("065  找出一个排序数组中的重复元素", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  若数组已排序，扫描相邻元素相等即可找重复值；要列出所有重复值时每组只输出一次并跳过后续重复项。若只判断是否存在且值域/单调谓词满足条件，可二分计数，但不能对任意排序数组凭空二分重复值。完整扫描 O(n)，先排序则通常 O(n log n)，题意需说明返回一个还是全部。", size: 9.5pt)
  #raw("// 相同元素在已排序数组中形成连续的一组。\nif (a.empty()) return;\nfor (int i = 0; i < a.size();) {\n    int j = i + 1; while (j < a.size() && a[j] == a[i]) ++j;\n    if (j - i > 1) duplicates.push_back(a[i]); // 每组只报告一次\n    i = j;\n}\n// 输入已排序，单次扫描 O(n)、O(1) 额外空间；返回一个重复值可提前停", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("066  拓扑排序（Topological Sorting）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Kahn 算法统计入度为零节点并逐个删除其出边；若输出节点数少于 V，则图中有环。DFS 算法沿边访问，完成节点后压栈，最后逆完成顺序输出；遇到当前递归栈中的节点表示有向环。时间 O(V+E)，拓扑序可能不唯一，可用优先队列按指定规则取零入度节点。 有多个合法序时，使用最小堆维护零入度节点可得到字典序最小结果。", size: 9.5pt)
  #raw("// 零入度队列逐步删除依赖；未输出顶点意味着图内有环。\nstd::queue<int> ready; for (int u = 0; u < n; ++u) if (indegree[u] == 0) ready.push(u);\nwhile (!ready.empty()) { int u = ready.front(); ready.pop(); order.push_back(u);\n    for (int v : graph[u]) if (--indegree[v] == 0) ready.push(v);\n}\nif (order.size() != n) return {}; // 仍有入度节点说明存在有向环\n// O(V+E) 时间；有多个零入度点时拓扑序不唯一", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("067  括号生成问题如何剪枝？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  构造过程中左括号最多放 n 个，右括号只有在 left > right 时才能放，从而每个前缀都保持合法，不必生成无效串再过滤。达到长度 2n 即输出；结果数量为第 n 个 Catalan 数，增长很快，时间至少与输出量相关。n=0 时通常产生一个空字符串，需依接口约定处理。 左括号数量达到 n 后只能闭合，闭合数追平时必须继续开新括号。", size: 9.5pt)
  #raw("// close 不得超过 open，所有递归前缀始终合法。\nvoid generate(int open, int close) {\n    if (path.size() == 2 * n) { out.push_back(path); return; }\n    if (open < n) { path.push_back('('); generate(open + 1, close); path.pop_back(); }\n    if (close < open) { path.push_back(')'); generate(open, close + 1); path.pop_back(); }\n}\n// close<=open 保证每个前缀合法；n=0 通常输出空串\n// 时间至少与 Catalan 数量级的输出量相同", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("068  插入排序（Insertion Sort）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  把左侧维持为有序区间，每轮取下一个元素，向右移动所有更大的元素，再将它放入空位；移动而非交换可保持相同元素的相对顺序。算法稳定、原地，最好近乎有序时 O(n)，平均和最坏 O(n²)。适合小规模或近乎有序数据，也常用于混合排序的短区间。 对含大量相等键的记录排序时，稳定性可以保留先前排序建立的次序。", size: 9.5pt)
  #raw("// 每轮开始时左侧区间有序，将当前值插入其正确位置。\nfor (int i = 1; i < n; ++i) { int value = a[i], j = i;\n    while (j > 0 && a[j - 1] > value) { a[j] = a[j - 1]; --j; } // 有序前缀右移\n    a[j] = value;\n}\n// 相等元素不移动，故稳定；原地，近乎有序最好 O(n)，平均/最坏 O(n²)", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("069  数组中的第 K 大元素如何求解？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  快速选择按 pivot 分区，只递归包含目标排名的一侧，平均 O(n)、最坏 O(n²)，适合一次静态查询；随机化 pivot 可降低常见退化。维护大小 K 的最小堆需 O(n log K) 时间、O(K) 空间，适合流式数据和 K 远小于 n。第 K 大对应升序下标 n-K，需处理 K 越界和重复值排名定义。", size: 9.5pt)
  #raw("// partition 将 pivot 放到最终排名，只继续目标所在一侧。\n// 三路 partition 避免重复值堆在某一侧；目标下标为 n-k\nif (k < 1 || k > a.size()) throw InvalidInput{};\nint target = static_cast<int>(a.size()) - k, left = 0, right = a.size() - 1;\nwhile (left <= right) { int pivot = a[left + (right - left) / 2], low = left, i = left, high = right;\n    while (i <= high) { if (a[i] < pivot) std::swap(a[low++], a[i++]);\n        else if (a[i] > pivot) std::swap(a[i], a[high--]); else ++i; }\n    if (target < low) right = low - 1; else if (target > high) left = high + 1; else return pivot;\n}\n// 快速选择平均 O(n)、最坏 O(n²)；随机 pivot 可降低常见退化\n// 流式数据可改用大小 K 的最小堆，时间 O(n log K)、空间 O(K)", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("070  斐波那契数列（Fibonacci Sequence）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  迭代从 F0、F1 开始滚动更新两项，避免朴素递归反复计算，时间 O(n)、额外空间 O(1)。整数位数随 n 增长，定宽类型会溢出；若要求模 M，可在每步取模。快速倍增用 F(2k)、F(2k+1) 关系可把运算次数降到 O(log n)。 Fibonacci 的增长近似指数级，测试时小心中间项溢出早于最终返回值。", size: 9.5pt)
  #raw("// prev/current 始终保存相邻两项，迭代避免重复递归。\nlong long fib(int n) { if (n < 0) throw InvalidInput{}; if (n <= 1) return n; // F0=0、F1=1\n    long long prev = 0, current = 1;\n    for (int i = 2; i <= n; ++i) { long long next = prev + current; prev = current; current = next; }\n    return current;\n}\n// O(n) 时间、O(1) 空间；定宽整数可能溢出，模运算按需逐步执行", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("071  旋转排序数组中的最小值", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  无重复元素时取中点与右端比较：nums[mid] 大于右端说明最小值在右侧，否则最小值在左侧含 mid，逐步缩小区间到单点。重复值且 nums[mid]==nums[right] 时无法判断哪边有旋转点，只能 right--，最坏退化 O(n)。边界为空数组时要先定义返回方式。 若数组未发生旋转，算法仍会返回首元素；旋转次数为零也覆盖在内。", size: 9.5pt)
  #raw("// 与右端比较后保留包含最小值的闭区间。\nif (a.empty()) throw EmptyInput{};\nint left = 0, right = static_cast<int>(a.size()) - 1;\nwhile (left < right) { int mid = left + (right - left) / 2;\n    if (a[mid] > a[right]) left = mid + 1;\n    else if (a[mid] < a[right]) right = mid;\n    else --right; // 重复值无法判定旋转点在哪边\n}\nreturn a[left]; // 无重复 O(log n)，含重复最坏 O(n)；未旋转也返回首元素", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("072  最大矩形问题（Maximal Rectangle）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  逐行扫描矩阵，当前为 1 的列高度加一，遇 0 清零；把每一行高度视为直方图，调用单调栈求最大矩形。若有矩形底边在该行，它的高恰好是各列连续 1 的高度，因此不会漏解。总时间 O(mn)、额外空间 O(n)，空行/空列应返回 0。 每列高度可原地保存在一维数组中，扫描下一行时只更新对应列。 每行均为零时该行最大面积为零，更新直方图后即可继续下一行。", size: 9.5pt)
  #raw("// height[c] 是当前行为底时该列连续 1 的高度。\nstd::vector<int> height(cols, 0);\nfor (const auto& row : matrix) {\n    for (int c = 0; c < cols; ++c) height[c] = row[c] == '1' ? height[c] + 1 : 0;\n    best = std::max(best, largestHistogram(height)); // 当前行作矩形底边\n}\nreturn best; // 每行 O(cols)，总 O(rows*cols)，额外 O(cols)\n// 空矩阵/空列返回 0；直方图子程序用单调栈求最大面积", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("073  最小生成树：Kruskal 算法", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  将边按权重升序排列，依次检查两端是否属于不同并查集；不同则选入 MST 并合并，形成环的边跳过。边排序 O(E log E)，并查集合并近似线性；若最终选边少于 V-1，原图不连通，只得到最小生成森林。负权边可正常处理，前提是无向图。 并查集按代表元判断两端是否已连通，而不是比较顶点编号本身。 若有相同权重，MST 可能不唯一，但 Kruskal 仍会得到一个最优生成树。", size: 9.5pt)
  #raw("// 仅合并不同并查集的边，已连通边会形成环而跳过。\nstd::sort(edges.begin(), edges.end(), [](const Edge& a, const Edge& b) { return a.weight < b.weight; });\nfor (const Edge& e : edges) if (dsu.unite(e.u, e.v)) {\n    mst.push_back(e); total += e.weight;\n    if (mst.size() == n - 1) break;\n}\nif (mst.size() != n - 1) reportForest(); // 原图不连通\n// O(E log E) 排序加近线性并查集；负权无向边可正常处理", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("074  最小生成树：Prim 算法", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  从任意顶点开始，把跨越已访问集合与未访问集合的候选边放入最小堆，每次取权重最小且终点尚未访问的边加入树。使用邻接表时堆优化复杂度通常 O(E log V)，稠密图也可用 O(V²) 数组实现。图不连通时需从多个连通分量启动，得到最小生成森林。 懒删除堆中已访问终点的旧候选边，可避免显式删除任意堆元素。", size: 9.5pt)
  #raw("// 候选堆维护已选集合的外边界，每个顶点只纳入一次。\nusing Candidate = std::pair<int, int>; // (权重, 顶点)\nstd::priority_queue<Candidate, std::vector<Candidate>, std::greater<Candidate>> q;\nfor (int start = 0; start < n; ++start) if (!used[start]) { q.push({0, start});\n    while (!q.empty()) { auto [w, u] = q.top(); q.pop(); if (used[u]) continue;\n        used[u] = true; total += w;\n        for (auto [v, cost] : graph[u]) if (!used[v]) q.push({cost, v});\n    }\n}\n// 外层覆盖不连通分量得最小生成森林；堆优化常见 O(E log V)", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("13.7 路径规划与动态规划", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("075  最小路径和（Minimum Path Sum）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  dp[i][j] 表示从左上到该格的最小代价，只能由上方或左方到达，故取二者较小值并加当前格权重。首行只能从左来、首列只能从上来，不能把未初始化状态当作 0。滚动一维数组可降至 O(n) 空间，时间 O(mn)；负权格不影响该网格无环方向转移。 若题目允许向右和向下以外的移动，网格 DP 的无环依赖假设便不成立。", size: 9.5pt)
  #raw("// dp[c] 在本行更新前是上方，更新后是左方最优代价。\nif (rows == 0 || cols == 0) return 0;\nconst int inf = std::numeric_limits<int>::max() / 4;\nstd::vector<int> dp(cols, inf); dp[0] = grid[0][0];\nfor (int r = 0; r < rows; ++r) for (int c = 0; c < cols; ++c) {\n    if (r == 0 && c == 0) continue;\n    int fromAbove = dp[c], fromLeft = c ? dp[c - 1] : inf;\n    dp[c] = grid[r][c] + std::min(fromAbove, fromLeft);\n}\nreturn dp[cols - 1]; // O(rows*cols) 时间、O(cols) 空间；避免 INF 加法溢出", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("076  最短路径问题：Bellman-Ford 算法", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  初始化源点距离为 0、其余为无穷，对所有边重复松弛 V-1 轮；若一轮没有更新可提前结束。再扫描可达边，若仍能降低距离，则存在从源点可达的负权环；不可达的负权环不会影响源点答案。时间 O(VE)，无负权环时适用于有负边图。 检测负环时只从距离有限的顶点松弛，防止无穷值加边权产生伪更新。 第 V 轮仅需扫描边检查是否还能松弛，不必再完整执行一轮更新。", size: 9.5pt)
  #raw("// 每轮松弛允许最短路再多经过一条边，V-1 轮覆盖简单路径。\nstd::vector<long long> dist(n, INF); dist[source] = 0;\nfor (int round = 1; round < n; ++round) { bool changed = false;\n    for (auto [u, v, w] : edges) if (dist[u] != INF && dist[u] + w < dist[v]) {\n        dist[v] = dist[u] + w; changed = true;\n    }\n    if (!changed) break;\n}\nfor (auto [u, v, w] : edges) if (dist[u] != INF && dist[u] + w < dist[v]) reportReachableNegativeCycle();\n// O(VE) 时间，可处理负边；只从可达点松弛以免 INF 溢出", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("077  最短路径问题：Dijkstra 算法", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Dijkstra 每次从最小堆取当前暂定距离最小的有效节点，再用它的距离松弛邻边；堆中旧条目若已过期应跳过。算法要求所有可达边权非负，否则已确定的距离还可能被后续负边改小。邻接表加二叉堆通常 O((V+E)logV)，单源不可达点保持无穷。 常见实现会把更短距离重新压入堆，并跳过过期堆项以简化 decrease-key。", size: 9.5pt)
  #raw("// 堆顶暂定距离若已过期就跳过，避免重复处理旧状态。\nstd::vector<long long> dist(n, INF); dist[source] = 0;\nusing State = std::pair<long long, int>; std::priority_queue<State, std::vector<State>, std::greater<State>> q;\nq.push({0, source});\nwhile (!q.empty()) { auto [d, u] = q.top(); q.pop(); if (d != dist[u]) continue; // 跳过过期条目\n    for (auto [v, w] : graph[u]) if (d + w < dist[v]) { dist[v] = d + w; q.push({dist[v], v}); }\n}\n// 仅适用于非负边；邻接表+堆 O((V+E)log V)，不可达点保持 INF", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("078  最长公共子串（Longest Common Substring）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  dp[i][j] 表示两个字符串分别以 i、j 位置结尾时的最长公共子串长度；字符相等时取左上状态加一，不同则清零，因为子串必须连续。遍历中记录最大长度及结束位置即可恢复答案。时间 O(mn)，滚动数组 O(min(m,n)) 空间，更新方向要避免覆盖尚未读取的左上状态。", size: 9.5pt)
  #raw("// 子串必须连续，字符不等时以该字符结尾长度归零。\nstd::vector<int> dp(b.size() + 1, 0); int best = 0;\nfor (char x : a) for (int j = static_cast<int>(b.size()); j > 0; --j) {\n    dp[j] = x == b[j - 1] ? dp[j - 1] + 1 : 0; // 不同字符必须清零\n    best = std::max(best, dp[j]);\n}\nreturn best; // 子串连续；逆序更新保护上一行左上状态\n// O(mn) 时间、O(n) 空间；可把较短串放在列维", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("079  最长公共子序列（Longest Common Subsequence, LCS）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  dp[i][j] 表示两个前缀的最长公共子序列长度；末尾字符相同则由左上加一，不同则取上方或左方较大值。子序列允许跳过字符，因此与公共子串的“不匹配归零”不同。时间 O(mn)，长度计算可用 O(min(m,n)) 滚动空间；恢复具体序列通常要保留方向信息或重新计算。 若只求长度可滚动压缩，若要输出序列则应保存矩阵或使用 Hirschberg 重建。", size: 9.5pt)
  #raw("// 子序列允许跳过字符，不匹配时取删去一侧末字符的较优状态。\nstd::vector<std::vector<int>> dp(a.size() + 1, std::vector<int>(b.size() + 1, 0));\nfor (int i = 1; i <= a.size(); ++i) for (int j = 1; j <= b.size(); ++j) {\n    if (a[i - 1] == b[j - 1]) dp[i][j] = dp[i - 1][j - 1] + 1;\n    else dp[i][j] = std::max(dp[i - 1][j], dp[i][j - 1]);\n}\nreturn dp.back().back(); // 子序列允许跳过字符，不要求连续\n// O(mn) 时间；只求长度可滚动为 O(min(m,n)) 空间，重建需留决策", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("080  最长无重复字符子串如何求解？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  用滑动窗口保证其中字符互不重复，并用哈希表记录字符最近位置；遇到位置在当前窗口内的重复字符，左边界更新为旧位置加一。更新边界要取 max(left, last[c]+1)，否则可能因窗口外旧字符错误地左退。每个字符处理一次，时间 O(n)，空间取决于字符集。 字节数组适用于 ASCII；UTF-8 文本应按码点或题目指定的字符单位处理。", size: 9.5pt)
  #raw("// 窗口左边界只能前进，哈希表记录字符最近出现下标。\nstd::unordered_map<char, int> last; int left = 0, best = 0;\nfor (int right = 0; right < s.size(); ++right) {\n    auto it = last.find(s[right]);\n    if (it != last.end()) left = std::max(left, it->second + 1); // 窗口左边界不后退\n    last[s[right]] = right; best = std::max(best, right - left + 1);\n}\nreturn best; // 每字符处理一次，平均 O(n) 时间，空间与字符集有关\n// UTF-8 输入若按码点判断，需先解码而不能直接以字节为字符", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("081  最长递增子序列（Longest Increasing Subsequence, LIS）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  O(n²) DP 对每个位置检查此前更小元素；优化做法维护长度为 L 的递增子序列能达到的最小尾值 tails[L-1]，二分找到首个不小于当前数的位置替换。tails 长度就是 LIS 长度，时间 O(n log n)、空间 O(n)。若要恢复具体序列，还需记录前驱和每个元素对应的 tails 位置。", size: 9.5pt)
  #raw("// tails 保存各长度的最小结尾，用 std::lower_bound 替换但不直接存真实子序列。\nstd::vector<int> tails;\nfor (int x : a) { auto it = std::lower_bound(tails.begin(), tails.end(), x);\n    if (it == tails.end()) tails.push_back(x); else *it = x;\n}\nreturn tails.size(); // tails[i] 是长度 i+1 的最小可行结尾\n// std::lower_bound 保证严格递增；O(n log n) 时间、O(n) 空间\n// 需要恢复具体序列时另存每项前驱和所在长度", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("13.8 栈、滑动窗口与数组优化", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("082  有效括号如何用栈判断？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  遇到左括号将其压栈；遇到右括号时栈必须非空且栈顶类型匹配，然后弹出。忽略其他字符还是将其判非法需服从题目定义，遍历结束栈也必须为空。每个字符至多入栈和出栈一次，时间 O(n)、空间 O(n)，只含一种括号时也可用计数器。 对混合类型括号，建议用映射表匹配而非只统计左、右括号总数。 遇到右括号后立即弹栈，能保证每个闭合符号都与最近未匹配左括号配对。", size: 9.5pt)
  #raw("// 每个右括号只匹配最近未配对的左括号。\nstd::stack<char> st;\nfor (char c : s) {\n    if (isOpening(c)) st.push(c);\n    else if (isClosing(c)) { if (st.empty() || !matches(st.top(), c)) return false; st.pop(); }\n    else if (otherCharactersAreInvalid) return false;\n}\nreturn st.empty(); // 所有左括号都必须匹配\n// O(n) 时间、O(n) 空间；单一种类括号可仅用计数器", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("083  查找数组中的最大值和最小值", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  非空数组先以首元素初始化 min 和 max，再遍历其余元素更新两者；这样全负数和重复值都能正确处理。时间 O(n)、额外空间 O(1)，空数组应返回错误状态而非读取首元素。若比较次数特别重要，可成对比较每组元素，再分别与全局最小和最大比较。", size: 9.5pt)
  #raw("// 从首元素初始化可兼容全负数组，不依赖 0 作为初值。\nif (a.empty()) return std::nullopt;\nint low = a[0], high = a[0];\nfor (int x : a) { low = std::min(low, x); high = std::max(high, x); }\nreturn std::pair<int, int>{low, high};\n// 全负数也正确；O(n) 时间、O(1) 额外空间\n// 需最少比较时可成对比较，再分别更新全局极值", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("084  查找数组中的重复元素", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  用哈希集合记录已见值，第二次及之后出现时可加入结果；若结果只需列每个重复值一次，还要用第二个集合或标记输出过的键。平均时间 O(n)、空间 O(n)，值可哈希且内存允许时简单可靠。已知值域并可修改输入时可考虑原地标记，但必须处理负数和重复计数。 若要统计每个重复值出现次数，可用哈希映射计数而不是仅返回集合。", size: 9.5pt)
  #raw("// 频次大于 1 的键才是重复值；若只求存在可提前返回。\nstd::unordered_map<int, int> frequency;\nfor (int x : a) ++frequency[x];\nfor (const auto& [value, count] : frequency) if (count > 1) duplicates.push_back(value);\n// 计数表可同时得到重复次数；平均 O(n) 时间、O(n) 空间\n// 只需判断是否有重复时，集合发现第二次即可提前返回", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("085  查找数组中缺失的最小正整数", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  对每个值 x，只要 1≤x≤n 且 nums[x-1] 不等于 x，就交换到下标 x-1；交换直到越界、重复或归位。随后首个 nums[i] 不等于 i+1 的位置给出缺失最小正整数，若全匹配则答案为 n+1。时间 O(n)、额外空间 O(1)，原地修改输入是该复杂度成立的条件。 交换时若目标位置已有同值要停止，否则重复值会在两个下标间无限互换。", size: 9.5pt)
  #raw("// 把值 x 放到下标 x-1，越界和重复值停止交换。\nfor (int i = 0; i < n; ++i) {\n    while (a[i] >= 1 && a[i] <= n && a[a[i] - 1] != a[i]) std::swap(a[i], a[a[i] - 1]);\n}\nfor (int i = 0; i < n; ++i) if (a[i] != i + 1) return i + 1;\nreturn n + 1; // 1..n 都归位后答案为 n+1\n// 越界和重复值直接停止交换；O(n) 时间、O(1) 空间但会修改输入", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("086  柱状图中的最大矩形（Largest Rectangle in Histogram）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  维护高度单调递增的下标栈；当前高度低于栈顶时弹出柱子，以其高度乘以当前右边界和新栈顶之间的宽度计算面积。末尾加 0 哨兵清栈，空数组返回 0。每根柱子至多入栈和弹出一次，时间与空间 O(n)；相同高度可保留一个代表或按一致规则弹出。 面积类型需容纳高度乘宽度，较大输入下 32 位整数可能溢出。 对零高柱子可正确清空较高柱子的最大延伸范围，不需额外分支。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("087  桶排序（Bucket Sort）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  把数据按值域映射到多个桶，在桶内排序，再按桶序连接结果；桶区间和数量应根据输入分布选择。均匀分布时每桶较小，平均可接近 O(n)，但极端集中在单桶时复杂度取决于桶内排序，可能退化。桶排序需要额外空间，浮点数需先定义有效范围和映射边界。 桶内元素分布若未知，可选插入排序等简单方法，也可再递归细分桶。 桶索引计算要保证最大值落入有效桶，避免上界恰好越界。", size: 9.5pt)
  #raw("// 桶索引按值域线性映射，最大边界需限制在最后一桶。\n// 空输入直接返回；非空时假设 high>low 且桶数 n>0\nif (a.empty()) return out;\nstd::vector<std::vector<double>> buckets(n);\nfor (double x : a) {\n    int id = static_cast<int>((x - low) / (high - low) * n);\n    id = std::min(n - 1, id); buckets[id].push_back(x);\n}\nfor (auto& bucket : buckets) std::sort(bucket.begin(), bucket.end());\nfor (const auto& bucket : buckets) out.insert(out.end(), bucket.begin(), bucket.end());\n// 均匀分布时平均接近 O(n)；集中一桶时退化为桶内排序复杂度\n// 额外空间 O(n)，上界映射需 clamp 防止下标等于 n", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("088  正则表达式匹配（Regular Expression Matching）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  针对仅含 `.` 和 `*` 的匹配题，dp[i][j] 表示文本前 i 个字符与模式前 j 个字符是否匹配；普通字符或点按对角线转移。模式中的星号作用于前一字符，可选择出现零次（跳过两位）或在当前字符匹配时延长一次。初始化空文本与连续星号很关键，算法 O(mn) 时间和空间，不等于支持完整正则语法。", size: 9.5pt)
  #raw("// 星号转移分为跳过前项与匹配后重复两种情况。\n// dp[i][j]：文本前 i 字符与模式前 j 字符匹配；模式不以 * 开头\nstd::vector<std::vector<bool>> dp(s.size() + 1, std::vector<bool>(p.size() + 1)); dp[0][0] = true;\nfor (int j = 2; j <= p.size(); ++j) if (p[j - 1] == '*') dp[0][j] = dp[0][j - 2];\nfor (int i = 1; i <= s.size(); ++i) for (int j = 1; j <= p.size(); ++j) {\n    if (p[j - 1] == '*') dp[i][j] = dp[i][j - 2] || ((p[j - 2] == '.' || p[j - 2] == s[i - 1]) && dp[i - 1][j]);\n    else dp[i][j] = (p[j - 1] == '.' || p[j - 1] == s[i - 1]) && dp[i - 1][j - 1];\n}\n// * 可取零次或延长一次；O(mn) 时间、空间，不代表完整正则语法", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("089  求解最大子数组和（Maximum Subarray Sum / Kadane's Algorithm）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  遍历每个数 x，维护以当前位置结尾的最大子数组和 cur=max(x,cur+x)，并用它更新全局最大值。若 cur 已为负，重新从 x 开始不会更差；全局答案应以首元素初始化，从而正确处理全负数组。时间 O(n)、空间 O(1)，空数组需按接口约定单独处理。 同步更新最大区间的起止下标，还能在线性扫描时恢复具体子数组。", size: 9.5pt)
  #raw("// ending 是必须以当前位置结尾的最优和，best 是全局最优。\nif (a.empty()) return 0; // 空数组按接口约定处理\nint ending = a[0], best = a[0];\nfor (int i = 1; i < a.size(); ++i) {\n    ending = std::max(a[i], ending + a[i]); // 从当前重开或延长前段\n    best = std::max(best, ending);\n}\nreturn best; // 全负数也正确；O(n) 时间、O(1) 空间", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("090  滑动窗口最大值如何在线性时间求解？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  双端队列保存下标且对应值单调递减；每步先移除已离开窗口的队首，再从队尾删除值不大于当前值的下标，最后读取队首最大值。下标用于判断过期，重复最大值可保留较新的一个。每个元素最多入队出队一次，整体 O(n) 时间、O(k) 空间，k 为窗口宽度。 先等至少 k 个元素进入窗口再输出，避免把尚未完整的窗口当结果。", size: 9.5pt)
  #raw("// 队列下标递增且对应值递减，过期从头、较小候选从尾删除。\nif (k <= 0 || k > a.size()) return maxima;\nstd::deque<int> q; // 下标对应值单调递减，队首为窗口最大值\nfor (int i = 0; i < a.size(); ++i) {\n    while (!q.empty() && q.front() <= i - k) q.pop_front();\n    while (!q.empty() && a[q.back()] <= a[i]) q.pop_back();\n    q.push_back(i); if (i >= k - 1) maxima.push_back(a[q.front()]);\n}\n// 每下标最多进出队一次，O(n) 时间、O(k) 空间；仅完整窗口输出", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("091  爬楼梯问题（Climbing Stairs）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  若每次可以爬 1 或 2 阶，到第 n 阶的最后一步来自 n-1 或 n-2，因此 dp[n]=dp[n-1]+dp[n-2]。按题目定义设置 n=0、n=1 的边界，再用两个变量滚动即可 O(n) 时间、O(1) 空间。n 大时计数可能快速超过整数范围，应使用大整数或按要求取模。", size: 9.5pt)
  #raw("// 每阶最后一步只能来自前一阶或前两阶。\nif (n == 0) return 1; // 空台阶通常有一种空走法\nlong long twoBack = 1, oneBack = 1; // F(0)=F(1)=1\nfor (int step = 2; step <= n; ++step) { long long ways = twoBack + oneBack;\n    twoBack = oneBack; oneBack = ways;\n}\nreturn oneBack; // O(n) 时间、O(1) 空间；大 n 注意计数溢出", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("092  线性查找和二分查找有什么区别？二分查找如何实现？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  线性查找逐项比较，不要求有序，时间 O(n)；二分查找需要有序且能快速访问中点，反复丢弃不可能区间，时间 O(log n)。实现前固定闭区间 [l,r] 或半开区间 [l,r)，并对应调整循环条件和边界更新。计算中点用 l+(r-l)/2 可避免 l+r 溢出，重复值要明确找任意、首个还是末个。 查找下界时要保留满足边界条件的那一半，循环终止点往往就是插入位置。", size: 9.5pt)
  #raw("// 线性扫描无需有序；二分半开区间返回 std::lower_bound 所在位置。\n// 线性查找不要求有序，逐项比较 O(n)\nfor (int i = 0; i < a.size(); ++i) if (a[i] == target) return i;\n// 二分要求有序且可 O(1) 访问中点；半开区间找首个 >= target\nint left = 0, right = a.size();\nwhile (left < right) { int mid = left + (right - left) / 2;\n    if (a[mid] < target) left = mid + 1; else right = mid;\n}\nreturn left; // std::lower_bound 插入位置，O(log n)；mid 公式避免加法溢出", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("093  编辑距离（Levenshtein Distance）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  令 dp[i][j] 为两个前缀互相转换的最小编辑次数，首行/首列分别初始化为插入或删除全部字符的代价。字符相同取左上值，不同则取插入、删除、替换三者最小值加一。时间 O(mn)，滚动数组可将长度计算降为 O(min(m,n)) 空间；恢复编辑操作需额外保存路径。 允许插入、删除和替换的代价不同时，可分别赋权修改三种转移。", size: 9.5pt)
  #raw("// diagonal 保存上一行左上，dp[j] 与 dp[j-1] 表示删除/插入候选。\nstd::vector<int> dp(b.size() + 1); std::iota(dp.begin(), dp.end(), 0); // 空前缀需插入 j 次\nfor (int i = 1; i <= a.size(); ++i) { int diagonal = dp[0]; dp[0] = i; // 删除 i 次\n    for (int j = 1; j <= b.size(); ++j) { int old = dp[j];\n        dp[j] = a[i - 1] == b[j - 1] ? diagonal : 1 + std::min({diagonal, dp[j], dp[j - 1]});\n        diagonal = old; // 保存上一行左上值\n    }\n}\n// O(mn) 时间、O(n) 空间；恢复操作序列需保存路径/决策", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("094  计数排序（Counting Sort）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先求整数值域最小值和最大值，用偏移后的计数数组统计每个值，再按频次输出；值域跨度 k 小时效率高。时间 O(n+k)、空间 O(k)，若值域很大或稀疏则不合适。需要稳定排序记录对象时，计算累积位置并从输入尾部向前放置，重复元素相对顺序才保持。 k 表示 max-min+1 的值域跨度，不能只看输入元素数量 n。", size: 9.5pt)
  #raw("// count[x-low] 统计偏移值出现次数，按计数回填整数。\nif (a.empty()) return;\nint low = *std::min_element(a.begin(), a.end()), high = *std::max_element(a.begin(), a.end());\nstd::vector<int> count(high - low + 1, 0);\nfor (int x : a) ++count[x - low];\nint write = 0; for (int i = 0; i < count.size(); ++i) while (count[i]-- > 0) a[write++] = i + low;\n// O(n+k) 时间、O(k) 空间，k=high-low+1；值域很大/稀疏时不适合\n// 稳定排序记录需改用累积位置并从输入尾部放置", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("095  选择排序（Selection Sort）", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  每轮在未排序区间扫描最小元素，与区间首元素交换，再缩小未排序边界；比较次数总是约 n(n-1)/2。空间 O(1)，交换次数至多 n-1，适合写入成本高而比较便宜的小规模场景。标准交换实现可能不稳定，存在相同键时不要假设原顺序保留。 与插入排序相比，选择排序的移动次数少，但几乎有序时仍做平方级比较。", size: 9.5pt)
  #raw("// 每轮定位未排序区最小项，只做一次最终交换。\nfor (int i = 0; i < n; ++i) { int minIndex = i;\n    for (int j = i + 1; j < n; ++j) if (a[j] < a[minIndex]) minIndex = j;\n    if (minIndex != i) std::swap(a[i], a[minIndex]); // 每轮最多一次交换\n}\n// 比较次数约 n(n-1)/2、空间 O(1)，交换少但时间仍 O(n²)\n// 标准交换版不稳定，近乎有序也不会明显减少比较", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("096  链表表示的两个数如何相加？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  从两个表示低位在前的链表头开始逐位相加，缺少节点时按 0 处理，并把和的个位写入新节点、十位作为进位。遍历条件必须包含任一链表未结束或进位非零，才能输出末尾进位。时间 O(max(m,n))，若数字按高位在前存储则需先反转、栈辅助或递归处理。 新建结果节点可避免修改输入链表；复用节点则要小心所有权与别名。", size: 9.5pt)
  #raw("// carry 保存十进位；循环条件必须包含尚未输出的末尾进位。\nNode dummy{}; Node* tail = &dummy; int carry = 0;\nwhile (a || b || carry) { int sum = carry + (a ? a->value : 0) + (b ? b->value : 0);\n    carry = sum / 10; tail->next = new Node{sum % 10}; tail = tail->next;\n    if (a) a = a->next; if (b) b = b->next;\n}\nreturn dummy.next; // 循环包含末尾进位，低位在前\n// O(max(m,n)) 时间；新建结果节点，不修改输入链表", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("097  除自身以外数组的乘积如何在 O(n) 且不除法求解？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  结果数组先写每个位置左侧所有元素的乘积，缺少左侧元素时为 1；再从右向左维护右侧乘积并乘入结果。整个过程不做除法，零值也自然处理，时间 O(n)、除输出外额外空间 O(1)。乘积可能远超元素类型范围，需根据约束使用更宽整数或大数。 若输入允许任意精度要求，应先确认数值范围，不能因无除法忽略溢出。 前缀和后缀乘积可分别独立检查，便于定位零值和边界初始化错误。", size: 9.5pt)
  #raw("// 前缀和后缀乘积均跳过当前位置，不使用除法。\nstd::vector<long long> out(a.size(), 1); long long prefix = 1;\nfor (int i = 0; i < a.size(); ++i) { out[i] = prefix; prefix *= a[i]; }\nlong long suffix = 1;\nfor (int i = static_cast<int>(a.size()) - 1; i >= 0; --i) {\n    out[i] *= suffix; suffix *= a[i];\n}\n// 前缀与后缀都不包含当前位置；O(n) 时间、输出外 O(1) 空间\n// 无除法可自然处理零值，乘积类型仍需符合数值范围", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("13.9 STL 容器使用与选择", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("098  std::vector 中 emplace_back 和 push_back 有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  push_back 接收已构造的 T，复制或移动到容器；emplace_back 转发构造参数，在尾部直接构造元素，例如 `v.emplace_back(a, b)`。已有 T 对象时两者通常都要移动/复制一次，emplace 并不天然更快；扩容时已有元素仍可能搬迁。还要留意完美转发可能选择不同构造函数重载。〔S2〕", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("099  std::vector 和 std::deque 如何选择？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  vector 元素连续，适合高效随机访问、缓存局部性和需要 data() 连续缓冲区的接口；尾插均摊 O(1)，但扩容可能搬迁元素并使指针、引用和迭代器失效。deque 随机访问也是 O(1)，两端插入删除通常 O(1)，但元素不保证整体连续且迭代器失效规则不同。若需频繁中间插入或稳定引用，还应比较 list 等容器的代价。〔S2〕", size: 9.5pt)
]

#heading(level: 1, outlined: true)[#text("第14章 Qt", size: 15pt, weight: "bold", fill: rgb("#000000"))]
#heading(level: 2, outlined: true)[#text("14.1 核心机制与容器", size: 14pt, weight: "bold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  QByteArray的使用场景是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QByteArray 保存的是原始字节，不解释字符编码，适合 socket 收发、压缩数据、文件内容和二进制协议；例如 UTF-8 文本先编码后可放入 QByteArray。转回文本时用 QString::fromUtf8 等明确解码，不能按字节数当字符数；需要 Unicode 文本运算时用 QString。", size: 9.5pt)
  #raw("QByteArray wire = QStringLiteral(\"猫\").toUtf8(); // 显式编码成字节\nwire.append('\\n'); // 协议分隔符也是字节\nsend(socket, wire); // 二进制数据不附带字符集信息\nconst QString decoded = QString::fromUtf8(wire); // 读回时按 UTF-8 解码\nconst int characters = decoded.size(); // 字符计数不等于 wire.size()\nQByteArray compressed = qCompress(wire); // 同一类型也可装任意二进制内容", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  QList、QVector、QLinkedList有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Qt 6 中 QList 与 QVector 使用相同的连续存储实现，QVector 作为兼容别名保留；QLinkedList 已在 Qt 6 移除，旧代码应考虑 std::list 或连续容器。顺序访问、遍历和尾部追加通常优先 QList；中间插入会搬移元素，链表虽便于已知位置插入却有额外节点和缓存未命中成本。", size: 9.5pt)
  #raw("QList<int> values{4, 1, 3}; // Qt 6 中 QList 连续存储\nvalues.append(2); // 尾部追加与顺序遍历常见\nstd::sort(values.begin(), values.end()); // Qt 容器可接标准算法\n// Qt 6 的 QVector 是 QList 的兼容别名，QLinkedList 已移除\nstd::list<int> nodes{4, 1, 3}; // 旧链表代码可评估 std::list\n// 已知位置插入虽方便，链表节点和缓存未命中也有成本", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  QMap和QHash有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QMap 按键排序，适合范围查询或需要稳定有序遍历的场合，查找、插入通常为 O(log n)；QHash 不保证顺序，按哈希平均查找更快，适合仅按键定位。哈希冲突会影响性能，自定义键要提供相等比较和 qHash；若结果要排序，可取出键后另行排序。若只需遍历顺序无关，应优先选更符合访问模式的容器，而非为排序额外付费。", size: 9.5pt)
  #raw("QMap<QString, int> ordered{{QStringLiteral(\"b\"), 2}, {QStringLiteral(\"a\"), 1}};\nfor (auto it = ordered.cbegin(); it != ordered.cend(); ++it)\n    consume(it.key(), it.value()); // QMap 按键排序\nQHash<QString, int> fast; fast.insert(QStringLiteral(\"a\"), 1);\nconst auto found = fast.constFind(QStringLiteral(\"a\"));\nif (found != fast.cend()) consume(found.value()); // 不依赖遍历顺序\n// 自定义 QHash 键还需相等比较与 qHash 实现", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  QString和std::string有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QString 是 Qt 的 Unicode 文本类型，便于与控件、翻译和字符串算法协作；std::string 只是字节容器，本身不携带 UTF-8、GBK 等编码信息。跨界时显式使用 toStdString/fromStdString 之外的编码转换，例如 toUtf8/fromUtf8；含非 ASCII 字符时不可直接按字节索引当作字符。", size: 9.5pt)
  #raw("const QString text = QStringLiteral(\"雪\");\nconst QByteArray utf8 = text.toUtf8(); // 明确写出编码\nstd::string bytes(utf8.constData(), static_cast<std::size_t>(utf8.size()));\nconst QString restored = QString::fromUtf8(bytes.data(), static_cast<qsizetype>(bytes.size()));\n// std::string 只保存字节，不携带编码；不要按字节下标当 Unicode 字符\nshowText(restored); // Qt 控件继续使用 QString", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  QVariant是什么？有什么应用场景？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QVariant 是带运行时类型信息的值容器，便于统一承载属性值、模型角色数据或查询结果，例如一个 DisplayRole 返回 QString、另一个 EditRole 返回整数。读取时用 value<T>() 或 toInt(&ok) 等并检查转换结果；自定义类型需注册元类型，接口设计时仍应明确预期类型，避免滥用动态类型。", size: 9.5pt)
  #raw("QVariant display = QStringLiteral(\"ready\"); // DisplayRole 可返回文本\nQVariant edit = 42; // EditRole 也可返回数值\nbool ok = false;\nconst int count = edit.toInt(&ok); // 动态转换要检查结果\nif (ok) updateCount(count);\nQVariant custom = QVariant::fromValue(MyValue{});\nqRegisterMetaType<MyValue>(); // 自定义类型跨元对象边界前注册", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  Qt QObject 父子对象树如何管理生命周期？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QObject 父对象析构时会递归删除仍归它所有的子对象，因此 QWidget 常把子控件设父对象来自动回收；父子对象必须处于同一线程；moveToThread() 会把无父对象的目标及其子对象一起迁移；不能有多个所有者重复 delete。无父对象者由调用方用栈对象、智能指针或明确所有权管理；deleteLater() 将删除延后到对象所属线程处理：若主事件循环已经停止，事件不会再处理；无事件循环的工作线程中，对象会在线程结束时销毁。", size: 9.5pt)
  #raw("QObject owner; // 栈对象先构造，也会先于局部 child 析构\nauto *child = new QObject(&owner); // parent 是唯一所有者且同线程\nauto *independent = new Worker; // 无 parent，由调用方负责\nindependent->moveToThread(&workerThread); // 只能移动无 parent 对象及其子树\nconnect(&workerThread, &QThread::finished, independent, &QObject::deleteLater);\nworkerThread.start(); // 退出时须 quit()、wait()，并让事件循环处理延迟删除\nchild->deleteLater(); // owner 仍会回收；延迟删除依赖所属线程事件循环", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("007  Qt 信号槽依赖什么机制？连接类型如何影响调用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  带 Q_OBJECT 的类由 moc 生成元对象代码，Qt 据此支持自定义信号、槽、属性和运行时调用；新式函数指针 connect 可在编译期检查签名。AutoConnection 在发射线程就是接收对象线程时直调，否则排队到接收线程事件循环；Direct 在发射线程同步调用，Queued 异步执行，BlockingQueued 会等待且同线程可能死锁。", size: 9.5pt)
  #raw("connect(worker, &Worker::resultReady, window, &Window::showResult);\nemit worker->resultReady(result); // AutoConnection 跨线程时排队\nconnect(worker, &Worker::progress, window, &Window::showProgress, Qt::QueuedConnection);\nconnect(this, &Controller::localUpdate, this, &Controller::updateNow, Qt::DirectConnection);\n// DirectConnection 在发射线程同步执行；不要用它跨线程碰 GUI\n// 同线程 BlockingQueuedConnection 会死锁，接收线程还必须运行事件循环", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("008  Qt 的隐式共享与写时复制是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Qt 隐式共享值类型以引用计数让多个副本暂时共用数据，复制通常只增加引用计数；其中一个副本写入时若仍共享，才分离并复制数据，这就是写时复制。它适合按值传递 QByteArray、QString 等，但不能把它当同步机制：不同线程共享对象时仍须遵循读写安全规则，迭代器失效也要按具体容器处理。", size: 9.5pt)
  #raw("QByteArray original(\"abc\");\nQByteArray copy = original; // 隐式共享：通常只复制引用计数头\ncopy[0] = 'A'; // 共享时写入会先分离再修改\nQ_ASSERT(original == QByteArray(\"abc\")); // 值对象彼此独立\nQ_ASSERT(copy == QByteArray(\"Abc\"));\n// 写时复制减少值传递开销，但不替代跨线程读写同步", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("009  Qt容器类和STL容器类有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Qt 容器与 STL 容器在接口、迭代器规则、算法生态和 Qt API 适配上不同；Qt 容器常有隐式共享，STL 则可配合标准算法、allocator 和范围库。Qt 6 中 QList 与 QVector 底层均连续，旧版表现不同；按项目版本、库边界和性能测量选用，跨库接口优先避免不必要的容器转换。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("010  一个信号可以连接多个槽吗？一个槽可以连接多个信号吗？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  可以，一个信号可连接多个槽，发射时会逐个调用已连接的接收端；一个槽也可接收多个信号，适合把多个来源汇入同一处理逻辑。参数类型须兼容，槽可以少接收信号末尾参数；动态初始化时注意重复 connect 会造成重复响应，可保存 QMetaObject::Connection 并按需断开。", size: 9.5pt)
  #raw("const auto first = connect(button, &QPushButton::clicked, this, &Window::save);\nconst auto second = connect(button, &QPushButton::clicked, this, &Window::submit);\n// 一次发射会调用两个接收端；同一槽也可连接多个信号\ndisconnect(first); // 按需移除某条连接\nQ_ASSERT(second); // 检查连接句柄仍代表有效连接\n// 重复初始化会重复响应；UniqueConnection 适用于成员函数连接\n// Lambda 需保存 QMetaObject::Connection 管理其连接生命周期", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("011  信号与槽的优缺点是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  信号槽让发送者只声明事件而不依赖接收者，函数指针形式通常能在编译期检查参数，也能通过队列连接跨线程调度。代价是连接与元对象分发有开销，调试异步调用链也需追踪发射点和连接点；跨线程排队不等于自动保护共享数据，GUI 控件仍须在主线程操作。要排查时可用 QObject::dumpObjectInfo() 查看对象连接关系，并记录关键发射点。", size: 9.5pt)
  #raw("connect(source, &Source::changed, view, &View::refresh, Qt::QueuedConnection);\nemit source->changed(value); // 发送方只发布事件，不依赖具体 UI 实现\n// 跨线程排队仅调度调用，不会锁住外部共享变量\n// 用 QObject::dumpObjectInfo() 查看连接与对象信息\nqInfo() << \"Source::changed emitted\" << value; // 记录异步链路关键点\n// GUI 接收端在主线程处理；锁和对象亲和性仍需独立遵守", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("012  如何自定义信号和槽？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  在 QObject 子类中声明 signals: void dataReady(const QByteArray &data);，发射处写 emit dataReady(bytes)，Qt 信号通常不自行实现函数体。槽可用普通成员函数或 Lambda，通过 QObject::connect(sender, &Sender::dataReady, receiver, &Receiver::handleData) 连接；自定义信号类需 Q_OBJECT，并确保构建系统运行 moc。", size: 9.5pt)
  #raw("class Worker : public QObject {\n    Q_OBJECT\nsignals:\n    void dataReady(const QByteArray &bytes); // 信号通常无需函数体\npublic slots:\n    void run() { emit dataReady(makePayload()); }\n};\nconnect(worker, &Worker::dataReady, receiver, &Receiver::handleData);\n// 含 Q_OBJECT 的类需要构建系统运行 moc", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("14.2 界面与绘图", size: 14pt, weight: "bold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  Graphics View框架是什么？适用于什么场景？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Graphics View 由场景、视图和图元组成，适合需要大量可选取、拖动、缩放或碰撞检测的二维对象，例如流程图编辑器、节点画布和地图标注。它管理场景坐标与视口变换，可让多个 view 显示同一 scene；若只是普通表单控件，直接用 Widgets 布局更简单。大量图元仍需通过索引、局部更新和绘制缓存实测优化。", size: 9.5pt)
  #raw("auto *scene = new QGraphicsScene(this); // 管理图元和场景坐标\nauto *item = scene->addEllipse(QRectF(0, 0, 24, 24), QPen(Qt::blue), QBrush(Qt::cyan));\nitem->setFlag(QGraphicsItem::ItemIsSelectable);\nauto *view = new QGraphicsView(scene, this); // 视图处理滚动与变换\nview->scale(1.5, 1.5); // 编辑器类场景可缩放和平移\n// 普通表单无需 Graphics View；大场景再测索引和局部更新", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  QGraphicsScene、QGraphicsView、QGraphicsItem的关系是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QGraphicsItem 是可绘制和交互的单个图元，可有父子变换关系；QGraphicsScene 管理图元集合、场景坐标、选择与碰撞查询；QGraphicsView 把场景映射到滚动视口并处理缩放、平移。一个 scene 能被多个 view 同时观察，例如主编辑区和缩略预览；item 不一定继承 QObject，需信号槽时可用 QGraphicsObject。", size: 9.5pt)
  #raw("auto *scene = new QGraphicsScene(this);\nauto *shape = scene->addRect(QRectF(0, 0, 80, 40)); // QGraphicsItem\nshape->setFlag(QGraphicsItem::ItemIsMovable);\nmainView->setScene(scene); // view 映射同一个 scene\npreviewView->setScene(scene); // 多个 view 可同时观察\npreviewView->scale(0.25, 0.25);\n// 需 QObject 信号槽的图元可改用 QGraphicsObject", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  QPaintDevice、QPaintEngine、QPainter的关系是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QPaintDevice 是绘制目标抽象，QWidget、QImage、QPixmap、打印机等都能作为设备；QPainter 提供画线、文本和变换等高层指令。实际输出由设备对应的 QPaintEngine 执行，例如窗口后端或图像光栅引擎，因此同一段 painter 代码可画到屏幕、图片或 PDF，但格式与性能受设备影响。", size: 9.5pt)
  #raw("QImage image(QSize(160, 80), QImage::Format_ARGB32_Premultiplied);\nimage.fill(Qt::transparent); // QImage 也是 paint device\n{\n    QPainter painter(&image); // QPainter 发出绘图指令\n    painter.drawText(QPoint(8, 32), QStringLiteral(\"preview\"));\n} // painter 结束后再读取或显示 image\nwidget->update(); // QWidget 由窗口绘制后端输出，不要长期持有 painter", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  QPainter的基本使用方法是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  自定义 QWidget 通常重写 paintEvent()，在函数内创建 QPainter painter(this)，按需设置 QPen、QBrush、字体和变换，再调用 drawLine、drawText 或 drawImage；函数返回后绘制结束。不要在任意时刻直接绘制 QWidget，数据变化后调用 update() 请求合并重绘，而非手动调用 paintEvent()；绘制设备若是 QImage，则在该图像上创建 painter。", size: 9.5pt)
  #raw("void PlotWidget::setValue(double value) {\n    value_ = value;\n    update(); // 请求事件循环合并重绘\n}\nvoid PlotWidget::paintEvent(QPaintEvent *event) {\n    QPainter painter(this); // 仅在 paintEvent 中画 QWidget\n    painter.setClipRegion(event->region()); // 只画失效区域\n    painter.drawLine(QPoint(8, 8), mapValue(value_));\n} // 不直接调用 paintEvent，也不在其中做 I/O", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  QPixmap、QImage、QBitmap有什么区别？使用场景是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QImage 是可直接访问像素的硬件无关图像，适合解码、逐像素处理和后台线程绘制；QPixmap 更适合界面显示，通常与窗口系统图像资源集成，跨平台实现不应假设它必然由 GPU 加速。QBitmap 是单色位图，常用于遮罩；实际图像处理可在线程中生成 QImage，再把结果交给 GUI 线程显示。", size: 9.5pt)
  #raw("// 后台线程解码和逐像素处理使用 QImage\nQImage decoded = QImageReader(path).read();\nif (decoded.isNull()) report(QStringLiteral(\"image decode failed\"));\nQImage processed = transform(decoded); // 线程间传值时按数据所有权处理\nQMetaObject::invokeMethod(this, [this, processed] {\n    label->setPixmap(QPixmap::fromImage(processed)); // GUI 线程显示\n}, Qt::QueuedConnection);\n// QBitmap 仅适合单色蒙版；不要假设 QPixmap 一定由 GPU 加速", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  QWidget、QDialog、QMainWindow有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QWidget 是 Widgets 控件和窗口的基础，可作为普通控件或顶层窗口；QDialog 增加对话框语义与 accept/reject 结果，适合短交互；QMainWindow 提供菜单栏、工具栏、状态栏和中央区域等主窗体结构。三者都需在 GUI 线程创建和操作，子控件通常交给布局管理器与 QObject 父子树管理。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("007  Qt Designer和手写代码创建界面有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Qt Designer 用拖放编辑 .ui 表单，构建时由 uic 生成界面初始化代码，适合稳定、常规的控件布局，调整视觉结构也直观。手写代码便于按数据动态生成组件、复用构造逻辑和做复杂定制；两者可以混用，例如 .ui 搭静态页面、代码绑定模型和运行时控件，避免重复手工维护生成文件。Designer 生成文件不建议直接手改；需复用自定义控件时可在表单中提升为子类。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("008  Qt中如何实现反走样（抗锯齿）？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  在绘制代码中调用 painter.setRenderHint(QPainter::Antialiasing)，可减少斜线和曲线边缘锯齿；文字可另外启用 TextAntialiasing，缩放图像时还可设 SmoothPixmapTransform。提示应在每次绘制时设置，效果依赖后端、设备像素比和变换；高频绘制需测量开销，不能只靠开抗锯齿解决低分辨率素材问题。", size: 9.5pt)
  #raw("void Canvas::paintEvent(QPaintEvent *) {\n    QPainter painter(this);\n    painter.setRenderHint(QPainter::Antialiasing); // 曲线与斜线\n    painter.setRenderHint(QPainter::TextAntialiasing); // 文字单独控制\n    painter.setRenderHint(QPainter::SmoothPixmapTransform); // 缩放图像\n    painter.drawEllipse(QPointF(40, 40), 25, 25);\n} // 效果受设备像素比、变换和绘图后端影响\n// 高频绘制要在目标设备测量开销", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("009  Qt中如何实现拖拽功能？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  拖放源端在 mouseMoveEvent 等事件中创建 QDrag，设置 QMimeData 携带文本、URL 或自定义格式，再调用 exec()；目标端启用 setAcceptDrops(true)，按需重写 dragEnterEvent、dragMoveEvent 和 dropEvent 并检查 MIME 格式。拖动对象使用 MIME 数据传递而非裸指针；若跨应用拖放，还需考虑动作类型、文件权限和平台行为。", size: 9.5pt)
  #raw("void SourceWidget::mouseMoveEvent(QMouseEvent *event) {\n    if (!dragging_) return;\n    auto *mime = new QMimeData;\n    mime->setText(selectedText()); // MIME 可跨 widget/应用传值\n    QDrag drag(this); drag.setMimeData(mime);\n    drag.exec(Qt::CopyAction | Qt::MoveAction);\n}\nvoid TargetWidget::dragEnterEvent(QDragEnterEvent *event) {\n    if (event->mimeData()->hasText()) event->acceptProposedAction();\n} // dropEvent 中再次校验 MIME，再读取文本", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("010  Qt中有哪些常用的布局管理器？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QHBoxLayout、QVBoxLayout 管理横向和纵向排列，QGridLayout 处理网格，QFormLayout 适合标签加输入框的表单，QStackedLayout 切换一组页面中的当前页。布局根据 sizeHint、伸缩因子和边距分配尺寸，可嵌套组合并随窗口缩放；一般把布局设到父 widget 上，不要同时手动设置子控件几何位置。", size: 9.5pt)
  #raw("auto *form = new QFormLayout;\nform->addRow(tr(\"Name\"), nameEdit); // 标签加输入框\nauto *grid = new QGridLayout;\ngrid->addWidget(formWidget, 0, 0); // 网格可放子布局\nauto *pages = new QStackedLayout;\npages->addWidget(pageA); pages->addWidget(pageB);\npages->setCurrentWidget(pageA); // 页面切换不重设子控件坐标\nparentWidget->setLayout(grid); // 布局接管几何分配和缩放", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("011  Qt样式表（QSS）是什么？如何使用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Qt Style Sheets 是类似 CSS 的控件样式规则，可用 QWidget::setStyleSheet() 或应用级设置统一背景、边框、字体及伪状态，例如 QPushButton:hover。选择器按对象名、类和属性匹配，范围过大的应用级样式可能覆盖平台原生观感；复杂绘制、布局和交互仍由控件或 QStyle 管理，QSS 不是完整 CSS。", size: 9.5pt)
  #raw("button->setObjectName(QStringLiteral(\"saveButton\"));\nbutton->setProperty(\"accent\", true); // 属性可供选择器匹配\nqApp->setStyleSheet(QStringLiteral(\n    \"QPushButton[accent=\\\"true\\\"] { background: #2878c8; }\"\n    \"QPushButton:hover { border: 1px solid white; }\"));\n// 应用级规则会覆盖较大范围；复杂绘制仍由控件/QStyle 实现\nbutton->setEnabled(false); // 样式不会替代交互状态逻辑", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("012  Qt的事件处理机制是什么？事件传递顺序是怎样的？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  事件循环从系统或队列取出事件并交给目标 QObject 的 event()，默认再分派到 mousePressEvent、paintEvent 等处理函数；也可用 sendEvent 同步发送或 postEvent 排队。某些被忽略的输入事件会继续传播到父控件，但并非所有事件都按固定链路冒泡；处理后 accept()，不处理则按事件类型决定是否 ignore()。", size: 9.5pt)
  #raw("class Target : public QWidget {\n    void mousePressEvent(QMouseEvent *event) override {\n        if (event->button() == Qt::LeftButton) event->accept();\n        else event->ignore(); // 某些输入事件可继续向父控件传播\n    }\n};\nQCoreApplication::postEvent(target, new MyEvent(payload)); // 排队稍后分发\n// sendEvent() 同步重入调用；事件循环调用 event() 再分派专用处理函数", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("013  event() 与事件过滤器有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  event() 是对象统一的事件入口，适合拦截多类事件或处理自定义 QEvent，并可调用基类维持默认分派。事件过滤器由另一个 QObject 对目标 installEventFilter()，在目标处理前观察或截断事件；过滤函数返回 true 表示已处理，返回 false 才继续交给目标，过滤器与目标必须处于同一线程。", size: 9.5pt)
  #raw("target->installEventFilter(this); // filter 与 target 必须同线程\nbool Filter::eventFilter(QObject *watched, QEvent *event) {\n    if (watched == target && event->type() == QEvent::MouseButtonPress) {\n        handlePress(static_cast<QMouseEvent *>(event));\n        return true; // 已处理，目标不会再收到该事件\n    }\n    return QObject::eventFilter(watched, event); // 保持默认过滤行为\n}", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("014  paintEvent()、resizeEvent()、mousePressEvent()等事件函数的作用是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  paintEvent() 负责绘制失效区域，通常由 update() 触发；resizeEvent() 在尺寸变化后通知控件，可重算缓存或布局相关状态；mousePressEvent() 等处理输入，并可读取按钮、位置和修饰键。它们是事件分派的专用虚函数，重写后应按需调用基类实现，且耗时工作不应放进 GUI 事件回调。", size: 9.5pt)
  #raw("void Canvas::resizeEvent(QResizeEvent *event) {\n    cachedSize_ = event->size(); // 重算与尺寸相关的缓存\n    QWidget::resizeEvent(event); // 按需保留基类行为\n}\nvoid Canvas::mousePressEvent(QMouseEvent *event) {\n    if (event->button() == Qt::LeftButton) { beginDrag(event->position()); return; }\n    QWidget::mousePressEvent(event);\n}\nvoid Canvas::paintEvent(QPaintEvent *) { QPainter(this).drawImage(rect(), cachedImage_); }\n// 事件回调只更新轻状态；耗时工作放到 worker", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("015  如何实现双缓冲绘图？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  双缓冲先把完整帧画入离屏图像，再一次性呈现，可避免逐笔刷新造成闪烁；但 QWidget 默认已采用双缓冲，一般只需在 paintEvent 中完整绘制更新区域。自定义动画可复用 QImage/QPixmap 缓存静态背景，再绘制动态层；缓冲区尺寸、设备像素比与失效更新范围要匹配窗口变化。只有在非 QWidget 设备上自行缓存时，才需要针对脏区域复制或重绘缓冲内容。", size: 9.5pt)
  #raw("// QWidget 已由 backing store 双缓冲，通常不需手写整窗缓冲\nvoid Canvas::setStaticLayer(const QImage &layer) {\n    cachedLayer_ = layer; update();\n}\nvoid Canvas::paintEvent(QPaintEvent *event) {\n    QPainter painter(this); painter.setClipRegion(event->region());\n    painter.drawImage(QPoint(0, 0), cachedLayer_); // 重用静态层\n    drawMovingObjects(painter); // 每帧只重绘变化部分\n}\n// 缓存需随尺寸/DPR 更新；避免保存多份全尺寸图像", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("016  如何实现自定义控件？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先选择合适基类，普通自绘控件继承 QWidget，需保留按钮语义则继承 QPushButton；再重写 paintEvent 和必要的鼠标、键盘或尺寸事件，并定义信号向外报告交互。提供 sizeHint()/minimumSizeHint() 让布局合理分配空间，设置焦点策略、可访问性和属性；资源应由父子树或 RAII 管理。", size: 9.5pt)
  #raw("class Meter : public QWidget {\n    Q_OBJECT\npublic:\n    QSize sizeHint() const override { return QSize(120, 32); }\nsignals:\n    void valueActivated(int value); // 交互用信号报告给外部\nprotected:\n    void paintEvent(QPaintEvent *) override { QPainter(this).drawText(rect(), text_); }\n    void mousePressEvent(QMouseEvent *) override { emit valueActivated(value_); }\n};\n// QWidget 子类留在 GUI 线程；父子树或 RAII 管理其资源", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("017  模态对话框和非模态对话框有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  模态对话框暂时阻止指定范围内的其他窗口交互，常用于必须先确认的短操作；非模态对话框通过 show() 打开，用户可继续使用主窗体，适合查找、监控和设置面板。QDialog::exec() 会启动嵌套事件循环并同步返回结果，open() 或 show() 配合 finished 信号通常更利于避免重入和保持异步流程。", size: 9.5pt)
  #raw("auto *dialog = new SettingsDialog(this); // parent 保证窗口对象活到关闭\nconnect(dialog, &QDialog::finished, dialog, &QObject::deleteLater);\nconnect(dialog, &QDialog::finished, this, &Window::applySettings);\ndialog->open(); // 非模态流程，不启动同步嵌套循环\n// 短操作可用 exec() 并检查 Accepted/Rejected\n// exec() 返回前 GUI 线程仍可重入处理其他事件", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("14.3 并发与网络", size: 14pt, weight: "bold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  QMutex、QReadWriteLock、QSemaphore有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QMutex 保证临界区同一时刻只有一个线程进入，适合保护普通共享状态；QReadWriteLock 允许并发读、独占写，适合读多写少但写者等待规则需考虑饥饿。QSemaphore 管理可用许可数，例如连接池最多开放 8 个并发槽位；用完要 release，避免资源计数泄漏。临界区可用 QMutexLocker 等 RAII 守卫，确保提前 return 或异常路径也会解锁。", size: 9.5pt)
  #raw("QMutex mutex;\n{\n    QMutexLocker lock(&mutex); // 所有访问共享状态的路径用同一把锁\n    ++sharedCount_;\n} // 提前 return 也会释放\nQReadWriteLock rw;\n{ QReadLocker read(&rw); inspect(sharedData_); } // 多读者\n{ QWriteLocker write(&rw); sharedData_ = next; } // 写者独占\nQSemaphore slots(8); // acquire 后使用许可，完成必须 release", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  Qt 中有哪些多线程方式？QThread 应如何使用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  简单一次性计算可用 QtConcurrent 或 QThreadPool；需要独立事件循环的长驻任务常用 QThread 加 worker-object：创建 QObject worker，moveToThread() 后以队列信号槽交互，并让 worker 在线程结束时 deleteLater。QThread 对象本身属于创建它的线程；GUI 控件留在主线程，退出时让 worker 协作检查取消请求，再 quit() 并 wait() 回收；quit() 不会打断正在执行的长函数。", size: 9.5pt)
  #raw("auto *thread = new QThread(this); // QThread 对象属于创建线程\nauto *worker = new Worker; worker->moveToThread(thread); // worker 无 parent\nconnect(thread, &QThread::started, worker, &Worker::process);\nconnect(worker, &Worker::finished, thread, &QThread::quit);\nconnect(thread, &QThread::finished, worker, &QObject::deleteLater);\nthread->start(); // 工作槽需要 worker 线程事件循环\n// 关闭时请求协作取消，再 quit() 并 wait()；quit 不打断长函数", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  QtConcurrent是什么？有什么应用场景？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QtConcurrent 提供高层并行算法和 QtConcurrent::run()，通常把工作提交到 QThreadPool，避免手工管理每个线程，适合独立的计算、压缩或批量处理任务。用 QFuture 表示结果，需要进度或完成通知时配 QFutureWatcher；它不适合操作 GUI 控件，结果应通过 watcher 信号或队列槽回到主线程。", size: 9.5pt)
  #raw("QFuture<Result> future = QtConcurrent::run([input] { return calculate(input); });\nauto *watcher = new QFutureWatcher<Result>(this);\nconnect(watcher, &QFutureWatcher<Result>::finished, this, [watcher] {\n    display(watcher->result()); // 回主线程显示结果\n    watcher->deleteLater();\n});\nwatcher->setFuture(future); // pool 管理工作线程\n// 任务不可直接访问 QWidget；长任务需设计取消与错误传播", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  Qt中如何实现线程安全？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先确定共享状态由哪个线程拥有；能避免共享时优先复制数据或消息传递，需要共享才用 QMutex/QReadWriteLock 保护所有相关读写。QObject 的线程亲和性不代表其方法可任意跨线程并发调用，事件驱动对象应在所属线程使用；跨线程用队列信号槽，并处理取消、退出和对象销毁顺序。互斥量只能保护遵守同一锁约定的访问者，锁外读写仍会产生数据竞争。", size: 9.5pt)
  #raw("// 优先让一个线程独占可变 QObject 状态\nconnect(worker, &Worker::resultReady, controller, &Controller::applyResult,\n        Qt::QueuedConnection);\nvoid Controller::applyResult(const Result &result) {\n    model_->replace(result); // 模型只在所属线程被修改\n    emit viewNeedsRefresh();\n}\n// 若必须共享裸数据，对所有读写统一加同一把锁\n// 线程亲和性本身不等于对象方法线程安全", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  Qt中如何实现线程间通信？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  最常见做法是发送者发信号、接收者位于工作线程或主线程，并使用 QueuedConnection，让槽在接收对象所属线程的事件循环处理。大数据也可用线程安全队列、QWaitCondition 或 QMutex 传递；参数应可复制或注册元类型，且线程事件循环必须运行，不能从 worker 直接更新 QWidget。", size: 9.5pt)
  #raw("connect(worker, &Worker::resultReady, window, &Window::showResult,\n        Qt::QueuedConnection);\nworker->startWork(); // 发射端可在工作线程\n// Qt 把槽排到 window 所在线程的事件循环\n// 参数类型需可复制；自定义类型跨队列要注册元类型\n// 事件循环未运行时队列槽不会处理\n// worker 只传结果，不直接访问 QWidget", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  如何避免多线程中的死锁？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  给多把锁规定全局固定获取顺序，并尽量缩小持锁区间，避免持锁等待另一个线程的信号、事件循环或 I/O。QMutex::tryLock(timeout) 可避免无限等待，但超时后仍需明确回滚策略；BlockingQueuedConnection、互相 join/wait 也会形成等待环，应做超时日志和可取消任务。", size: 9.5pt)
  #raw("// 多锁统一规定顺序：先 accountMutex，再 ledgerMutex\nQMutexLocker first(&accountMutex);\nif (!ledgerMutex.tryLock(100)) {\n    rollbackLocalChanges(); // 超时也要恢复一致状态\n    return;\n}\nQMutexLocker second(&ledgerMutex, QMutexLocker::AdoptLock);\ncommitTransfer(); // 尽量缩短临界区\n// 持锁时不要同步等待信号、I/O、另一线程 wait() 或阻塞队列槽", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("14.4 数据、模型与事件", size: 14pt, weight: "bold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  Delegate 的作用是什么？如何自定义 Delegate？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Delegate 把模型项渲染到视图并提供可选编辑器，避免为每个单元格创建真实控件。自定义时继承 QStyledItemDelegate，重写 paint() 和 sizeHint() 控制显示，需要编辑再实现 createEditor、setEditorData、setModelData；例如状态列可画彩色圆点，编辑列用 QComboBox。", size: 9.5pt)
  #raw("void StatusDelegate::paint(QPainter *p, const QStyleOptionViewItem &o,\n                            const QModelIndex &i) const {\n    const bool active = i.data(Qt::UserRole).toBool();\n    p->setBrush(active ? Qt::green : Qt::gray);\n    p->drawEllipse(o.rect.center(), 5, 5); // 绘制可见单元格，无常驻 QWidget\n}\nQWidget *StatusDelegate::createEditor(QWidget *parent, const QStyleOptionViewItem &,\n                                      const QModelIndex &) const {\n    return new QComboBox(parent); // 编辑时才创建 editor\n} // setEditorData/setModelData 在编辑器和 model 间传值", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  Model / View 中的数据角色（Role）是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Role 是 QModelIndex 上按用途索取数据的整数标识：DisplayRole 给视图展示，EditRole 给编辑器，DecorationRole 常放图标，ToolTipRole 给提示。模型的 data(index, role) 按角色返回 QVariant；自定义角色从 Qt::UserRole 起定义，并在 QML 等场景通过 roleNames() 暴露稳定名称。", size: 9.5pt)
  #raw("QVariant TaskModel::data(const QModelIndex &i, int role) const {\n    if (!i.isValid() || i.row() >= tasks_.size()) return {};\n    const Task &task = tasks_[i.row()];\n    if (role == Qt::DisplayRole) return task.title;\n    if (role == Qt::DecorationRole) return task.icon;\n    if (role == Qt::UserRole) return task.done;\n    return {};\n}\n// 自定义角色集中声明；QML 列表模型还实现 roleNames()\n// 视图按角色取值，不要把所有数据塞成一个显示字符串", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  QAbstractItemModel 的作用是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QAbstractItemModel 定义视图读取行列、父子层级、数据和编辑状态的协议，使同一数据源可连接不同 View。简单列表可继承 QAbstractListModel，只需正确实现 rowCount()、data()，表格还实现 columnCount()；插删数据必须用 beginInsertRows/endInsertRows 等通知视图维护索引和选择。", size: 9.5pt)
  #raw("int TaskModel::rowCount(const QModelIndex &parent) const {\n    return parent.isValid() ? 0 : static_cast<int>(tasks_.size());\n}\nQVariant TaskModel::data(const QModelIndex &i, int role) const {\n    if (!i.isValid() || i.row() < 0 || i.row() >= rowCount()) return {};\n    if (role == Qt::DisplayRole) return tasks_[i.row()].title;\n    return {};\n}\n// QAbstractListModel 把数据接口提供给 QListView/QML；修改时必须发模型通知", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  QCoreApplication::processEvents() 的作用是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  processEvents() 在当前线程同步分发待处理事件，常用于少量必须保持响应的初始化循环，但可能让尚未完成的对象被重入调用，形成状态竞争。它也不能让耗时计算变快，频繁调用会掩盖主线程阻塞；长任务应移到 worker 或拆成定时小步，并由事件循环自然调度。尤其不能在模型通知、半初始化控件或持锁期间嵌套处理任意事件。", size: 9.5pt)
  #raw("// 不用 processEvents() 在长循环里反复嵌套分发任意回调\nauto *watcher = new QFutureWatcher<Result>(this);\nconnect(watcher, &QFutureWatcher<Result>::finished, this, [watcher] {\n    showResult(watcher->result()); watcher->deleteLater();\n});\nwatcher->setFuture(QtConcurrent::run([input] { return compute(input); }));\n// 少量可切成 QTimer::singleShot() 小步任务\n// 持锁、改模型通知或对象半初始化时绝不嵌套处理事件", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  QDataStream和QTextStream有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QDataStream 将 Qt/C++ 值按二进制格式序列化，适合结构化存档或协议，但需固定 stream version、字节序及字段顺序以兼容不同版本。QTextStream 面向可读文本，处理字符编码、行文本和格式化；跨机器传文件时显式约定编码，Qt 6 的默认文本编码是 UTF-8。", size: 9.5pt)
  #raw("QDataStream binary(&file);\nbinary.setVersion(QDataStream::Qt_6_0); // 固定序列化版本\nbinary.setByteOrder(QDataStream::BigEndian); // 文件格式显式约定字节序\nbinary << quint32(1) << record.id << record.name; // 结构化二进制\nif (binary.status() != QDataStream::Ok) report(binary.status());\nQTextStream text(&textFile); text.setEncoding(QStringConverter::Utf8);\ntext << record.name << '\\n'; // 面向可读文本\n// 读不可信长度时先限幅，再分配内存", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  QFile、QFileInfo、QDir的作用是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QFile 提供文件打开、读取、写入和复制等 I/O；QFileInfo 查询路径对应的大小、时间、权限等元数据；QDir 用于遍历、创建目录和路径组合。比如用 QDir::entryInfoList() 列出文件，再由 QFile 打开目标；检查 open() 返回值与 errorString()，路径应按输入来源做校验。", size: 9.5pt)
  #raw("QDir dir(rootPath);\nfor (const QFileInfo &info : dir.entryInfoList(QDir::Files)) {\n    if (!isAllowed(info.fileName())) continue; // 校验输入路径/名称\n    QFile file(info.filePath());\n    if (!file.open(QIODevice::ReadOnly)) { qWarning() << file.errorString(); continue; }\n    consume(file.readAll()); // QFile 析构关闭文件\n    qInfo() << info.size() << info.lastModified();\n}\n// 组合路径用 QDir，不手工拼平台分隔符", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("007  QListView、QTableView、QTreeView 有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QListView 以一维方式显示项，QTableView 展示行列数据，QTreeView 展示 QModelIndex 父子层级；三者都可连接同一个自定义 model。大量数据应选 model/view 而非为每条记录创建 widget，例如文件列表用 QFileSystemModel 接 QListView，表格用 QAbstractTableModel 接 QTableView。", size: 9.5pt)
  #raw("auto *model = new QFileSystemModel(this);\nmodel->setRootPath(rootPath); // 层级数据由模型管理\nlistView->setModel(model); // 一维项\ntableView->setModel(model); // 行列数据\ntreeView->setModel(model); // 父子层级\ntreeView->setRootIndex(model->index(rootPath));\n// 大量记录用 model/view 和 delegate，避免每行创建 QWidget", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("008  QNetworkAccessManager的作用是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QNetworkAccessManager 统一发起 HTTP 等请求，异步返回 QNetworkReply，可监听 finished、downloadProgress 和错误信号，不会像同步等待那样阻塞界面。通常每个线程复用一个 manager，manager 与 reply 在其所属线程事件循环工作；完成后读 reply 数据、处理错误并 deleteLater()，不能立刻跨线程读取。", size: 9.5pt)
  #raw("auto *manager = new QNetworkAccessManager(this); // 在线程内复用\nQNetworkReply *reply = manager->get(QNetworkRequest(QUrl(url)));\nconnect(reply, &QNetworkReply::finished, this, [reply] {\n    if (reply->error() == QNetworkReply::NoError) consume(reply->readAll());\n    else qWarning() << reply->errorString();\n    reply->deleteLater(); // 读完再延迟销毁\n});\n// manager/reply 由所属线程事件循环驱动，不在别的线程直接读取", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("009  QSettings的作用是什么？如何使用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QSettings 按组织名、应用名或显式文件名保存键值配置，平台默认可落到注册表、INI 等位置。示例：settings.setValue(\"window/size\", size)，重启后用 value(key, default).toSize() 读取；用 beginGroup()/endGroup() 管理层级，敏感凭据不应因为方便就明文存入普通配置。", size: 9.5pt)
  #raw("QSettings settings;\nsettings.beginGroup(QStringLiteral(\"window\"));\nsettings.setValue(QStringLiteral(\"size\"), size());\nsettings.endGroup();\nsettings.sync(); // 写回后检查持久化状态\nif (settings.status() != QSettings::NoError) reportSettingsError();\nconst QSize saved = settings.value(QStringLiteral(\"window/size\"), QSize(800, 600)).toSize();\n// 普通配置不存明文口令，升级时按版本迁移键值", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("010  QSqlDatabase、QSqlQuery、QSqlTableModel的作用是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QSqlDatabase 表示驱动和连接，负责设置数据库路径、主机与登录参数；QSqlQuery 执行 SQL、绑定参数并遍历结果；QSqlTableModel 把单表接到 Qt 视图并可编辑。数据库连接只能在创建它的线程访问，后台线程需建立自己的命名连接；跨线程共享同一连接是不安全的。连接名应避免冲突，多个数据库或后台任务宜显式命名而不依赖默认连接。", size: 9.5pt)
  #raw("const QString name = QUuid::createUuid().toString();\nQSqlDatabase db = QSqlDatabase::addDatabase(QStringLiteral(\"QSQLITE\"), name);\ndb.setDatabaseName(filePath);\nif (!db.open()) return report(db.lastError());\n{ QSqlQuery query(db); query.prepare(QStringLiteral(\"SELECT name FROM user WHERE id=?\"));\n  query.addBindValue(userId); if (!query.exec()) report(query.lastError()); }\n// 连接在哪个线程创建就在哪个线程使用\ndb.close(); db = {}; QSqlDatabase::removeDatabase(name); // 先销毁 query/model/副本", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("011  QSqlQueryModel、QSqlTableModel、QSqlRelationalTableModel有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QSqlQueryModel 用自定义查询结果构建只读模型，适合 join 或聚合报表；QSqlTableModel 围绕一张表并提供修改、插删和提交策略；QSqlRelationalTableModel 在单表基础上把外键值映射为关联表字段。复杂多表编辑通常需自定义模型或拆分事务，不能把只读查询模型当成可写表。", size: 9.5pt)
  #raw("QSqlQueryModel reportModel(this);\nreportModel.setQuery(QStringLiteral(\"SELECT department, count(*) FROM staff GROUP BY department\"), db);\n// 自定义 JOIN/聚合通常用查询模型，只读展示\nQSqlTableModel editable(this, db); editable.setTable(QStringLiteral(\"employee\"));\neditable.select(); // 单表编辑使用 QSqlTableModel\nQSqlRelationalTableModel related(this, db);\nrelated.setTable(QStringLiteral(\"order\")); // 外键可映射关联表显示\n// 多表编辑需自定义提交/事务边界", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("012  QTcpSocket和QUdpSocket的使用场景是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QTcpSocket 建立面向连接的可靠有序字节流，适合登录、文件传输等需要完整顺序的业务，但 TCP 不保留应用消息边界。QUdpSocket 发送独立数据报，适合发现、组播、实时状态；它可能丢包、乱序或重复，需由协议自行处理。两者异步读写都依赖对象线程的事件循环。UDP 的最大载荷受路径 MTU 影响，过大数据报会分片并增大丢失概率。", size: 9.5pt)
  #raw("QTcpSocket tcp; tcp.connectToHost(host, port); // 可靠有序字节流\nconnect(&tcp, &QTcpSocket::readyRead, this, &Client::appendTcpBytes);\nQUdpSocket udp; udp.bind(QHostAddress::AnyIPv4, 0);\nudp.writeDatagram(payload, serverAddress, serverPort); // 独立数据报\n// TCP 需自行定义消息边界；UDP 要处理丢失、乱序与重复\n// 两类 socket 都需在有事件循环的所属线程中使用", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("013  QTimer 的使用方法是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  创建 QTimer 并连接 timeout()，调用 setInterval(ms) 和 start() 即可周期触发；setSingleShot(true) 或 singleShot() 用于延时一次执行。定时器事件由对象所属线程的事件循环投递，回调繁忙时会延迟，不能用于硬实时测量；精确经过时间应用 QElapsedTimer 计时。", size: 9.5pt)
  #raw("QElapsedTimer elapsed; elapsed.start(); // 测实际经过时间\nQTimer timer(this); timer.setInterval(500); // 事件循环驱动的周期回调\nconnect(&timer, &QTimer::timeout, this, [this] { refreshView(); });\ntimer.start();\n// 所属线程必须有事件循环；回调繁忙会延迟触发\n// QTimer 不是硬实时计时器，不用 timeout 间隔测精确耗时", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("014  Qt 中有哪些实现定时器的方式？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QTimer 提供信号槽、单次/周期启动和调整间隔，适合绝大多数界面定时任务；QObject::startTimer() 返回 ID，需在 timerEvent() 中分辨并处理；QBasicTimer 是轻量封装，可管理该 ID。三种都由所属线程事件循环驱动，精度受系统调度和繁忙事件队列影响。", size: 9.5pt)
  #raw("QTimer highLevel(this); // timeout 信号和单次/周期 API\nconnect(&highLevel, &QTimer::timeout, this, &Worker::tick);\nhighLevel.setSingleShot(true); highLevel.start(200);\nconst int timerId = startTimer(1000); // 低层 ID 由对象管理\nvoid Worker::timerEvent(QTimerEvent *e) {\n    if (e->timerId() == timerId) doSmallStep();\n    else QObject::timerEvent(e);\n}\n// 两种方式都依赖对象线程事件循环", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("015  Qt 的事件循环机制是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  事件循环从系统窗口事件和 Qt 队列取出事件，分发到 QObject 的 event()，并运行排队槽、定时器及网络通知；GUI 主循环由 QApplication/QCoreApplication::exec() 启动，工作线程可用 QThread::exec()。某线程没有事件循环时，定时器和队列槽等事件驱动功能不能正常投递，长时间阻塞也会暂停处理。", size: 9.5pt)
  #raw("int main(int argc, char **argv) {\n    QApplication app(argc, argv); // 创建 GUI 应用上下文\n    MainWindow window; window.show();\n    QTimer::singleShot(0, &window, &MainWindow::startAsyncWork);\n    return app.exec(); // 网络/定时器/排队槽由主循环分发\n}\n// 工作线程需自己的 exec() 才能处理该线程的 queued slot 和 QTimer\n// 长时间阻塞某线程会暂停该线程的事件处理", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("016  Qt 的模型 / 视图（Model / View）架构是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Model 保存并提供数据，View 负责浏览与选择，Delegate 负责单元格绘制和编辑，三者经 QModelIndex、数据角色和模型通知协作。模型发出 dataChanged 或 begin/end 插入删除通知后，视图局部更新；同一模型可接多个视图，例如表格与汇总列表同步观察一份业务数据。", size: 9.5pt)
  #raw("class TaskModel : public QAbstractListModel { /* 数据与 role API */ };\nTaskModel model;\nQListView list; QTableView table;\nlist.setModel(&model); table.setModel(&model); // 两个视图观察同一份数据\nmodel.setData(model.index(0, 0), QStringLiteral(\"done\"), Qt::EditRole);\n// 模型发 dataChanged/插删通知后视图更新\n// Delegate 管绘制与编辑，View 管选择和呈现", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("017  Qt中如何实现JSON数据的解析和生成？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  用 QJsonDocument::fromJson(bytes, &error) 解析，检查 QJsonParseError 后按根类型读取 QJsonObject 或 QJsonArray；字段还应验证类型和默认值。生成时组装对象/数组，再用 toJson(QJsonDocument::Compact) 得到 QByteArray；适合 HTTP API，若需大文档流式处理则考虑增量解析而非一次载入内存。", size: 9.5pt)
  #raw("QJsonParseError error;\nconst QJsonDocument doc = QJsonDocument::fromJson(bytes, &error);\nif (error.error != QJsonParseError::NoError || !doc.isObject()) return report(error);\nconst QJsonObject object = doc.object();\nif (!object.value(\"id\").isDouble()) return reportSchemaError();\nQJsonObject response{{\"ok\", true}, {\"id\", object.value(\"id\")}};\nconst QByteArray output = QJsonDocument(response).toJson(QJsonDocument::Compact);\n// 大文档流式读取可用 QJsonStreamReader 等分段方案", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("018  Qt中如何实现WebSocket通信？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  客户端用 QWebSocket::open() 发起 ws/wss 握手，连接 connected、textMessageReceived、binaryMessageReceived、errorOccurred 和 disconnected 后收发完整 WebSocket 消息；服务端用 QWebSocketServer 监听并管理接入 socket。生产环境要验证 TLS 证书、鉴权、消息大小和断线重连，事件驱动 socket 必须在有事件循环的所属线程操作。", size: 9.5pt)
  #raw("QWebSocket socket; // 对象需存活在事件循环线程\nconnect(&socket, &QWebSocket::connected, this, [&socket] {\n    socket.sendTextMessage(QStringLiteral(\"hello\"));\n});\nconnect(&socket, &QWebSocket::textMessageReceived, this, &Client::onMessage);\nconnect(&socket, &QWebSocket::errorOccurred, this, &Client::onError);\nconnect(&socket, &QWebSocket::disconnected, this, &Client::scheduleReconnect);\nsocket.open(QUrl(QStringLiteral(\"wss://example.invalid/socket\")));\n// 校验证书、限制消息大小，并为断线重连设置退避", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("019  Qt中如何实现XML数据的解析？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QXmlStreamReader 是前向流式解析器，逐个读取 startElement、属性和文本，内存占用适合大文件；解析中要检查 hasError() 并报告行列位置。需要生成时用 QXmlStreamWriter 保证转义正确；若业务必须随机查询完整树，可考虑 DOM，但 Qt 6 已移除旧 SAX 类，应按目标版本选 API。", size: 9.5pt)
  #raw("QXmlStreamReader xml(&file); // 前向解析，适合大文件\nwhile (!xml.atEnd()) {\n    xml.readNext();\n    if (xml.isStartElement() && xml.name() == u\"item\")\n        consume(xml.attributes().value(u\"id\").toString());\n}\nif (xml.hasError()) report(xml.errorString(), xml.lineNumber(), xml.columnNumber());\nQXmlStreamWriter writer(&out); writer.writeStartDocument();\nwriter.writeTextElement(QStringLiteral(\"name\"), userText); // 自动转义\nwriter.writeEndDocument(); // DOM 仅在需要随机访问整棵树时载入", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("020  Qt中如何读写文本文件和二进制文件？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  文本可用 QFile 加 QTextStream，读写时明确 UTF-8 等编码、换行和错误状态；二进制原始字节直接通过 QFile::read/write，结构化二进制可用 QDataStream。持久化格式要固定 QDataStream::Version 并在格式中写版本号，读取不可信输入时检查长度和流状态，避免错误数据导致超大分配。", size: 9.5pt)
  #raw("QFile binary(path);\nif (!binary.open(QIODevice::WriteOnly)) return report(binary.errorString());\nQDataStream out(&binary); out.setVersion(QDataStream::Qt_6_0);\nout << quint32(formatVersion) << payload; // 结构化二进制\nQFile textFile(textPath); if (!textFile.open(QIODevice::WriteOnly)) return;\nQTextStream text(&textFile); text.setEncoding(QStringConverter::Utf8);\ntext << QString::fromUtf8(message); // 编码与字节序显式约定\n// 读取外部文件要验证长度和流状态后再使用数据", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("021  Qt中如何连接数据库？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先用 QSqlDatabase::addDatabase(\"QSQLITE\", connectionName) 创建连接，设置文件名并 open()，随后检查 lastError()；其他驱动还需主机、用户名、密码等参数。用完先销毁所有 QSqlQuery/QSqlTableModel 和数据库副本，再 removeDatabase(connectionName)，避免仍有引用时移除产生警告或悬空使用。", size: 9.5pt)
  #raw("const QString connection = QUuid::createUuid().toString();\n{\n    QSqlDatabase db = QSqlDatabase::addDatabase(QStringLiteral(\"QSQLITE\"), connection);\n    db.setDatabaseName(filePath);\n    if (!db.open()) return report(db.lastError());\n    { QSqlQuery query(db); runQueries(query); } // query 先离开作用域\n    db.close();\n} // 清除所有 QSqlDatabase 副本、model 后再 remove\nQSqlDatabase::removeDatabase(connection); // 否则仍引用连接会告警", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("022  Qt中有哪些网络编程相关的类？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  TCP 服务端/客户端用 QTcpServer、QTcpSocket，UDP 用 QUdpSocket，HTTP 请求用 QNetworkAccessManager，WebSocket 用 QWebSocket/QWebSocketServer。文件与配置可由 QFile/QSettings 处理，SQL 用 Qt SQL；网络对象通常依赖其线程事件循环，选择模块前确认目标 Qt 版本、构建组件和平台插件已部署。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("023  exec() 函数的作用是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QCoreApplication::exec() 启动应用主事件循环并在退出时返回状态码；QDialog::exec() 启动嵌套局部循环并返回接受/拒绝结果，常用于模态对话框。嵌套 exec 会带来重入风险，异步界面更适合 show()/open() 后监听 finished；QThread::exec() 则为工作线程处理其队列事件。", size: 9.5pt)
  #raw("QCoreApplication app(argc, argv);\nQTimer::singleShot(0, &worker, &Worker::processChunk); // 让循环自然回到事件队列\nreturn app.exec();\n// processEvents() 会同步重入当前线程所有已排队事件\n// 不能在半初始化对象、发模型通知或持锁时调用\n// 长任务应异步拆分或交给 worker，而非插入嵌套事件泵", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("024  startTimer() 和 QTimer 有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QTimer 把超时封装为 timeout() 信号，支持 start/stop、周期及单次配置，调用代码更清晰；startTimer() 直接返回定时器 ID，需要在 timerEvent() 判断 ID 并自行管理生命周期。它们都不创建独立计时线程，定时回调在对象亲和线程运行并受该线程事件循环负载影响。", size: 9.5pt)
  #raw("class TimerOwner : public QObject {\n    void startLowLevel() { timerId_ = startTimer(250); }\n    void timerEvent(QTimerEvent *event) override {\n        if (event->timerId() == timerId_) poll();\n        else QObject::timerEvent(event);\n    }\n    int timerId_ = 0;\n};\nQTimer high(this); connect(&high, &QTimer::timeout, this, &TimerOwner::poll);\n// 高层信号 API 更清楚；两者精度都受事件循环调度", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("025  如何使用QTcpServer实现服务器？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  创建 QTcpServer 后调用 listen(address, port)，收到 newConnection() 时用 nextPendingConnection() 取 socket，并连接 readyRead、disconnected 和 error 信号；每个连接要有独立缓冲并及时释放。TCP 是字节流，接收端需按长度前缀或分隔符拼出完整消息，同时限制最大包长并处理客户端断开。", size: 9.5pt)
  #raw("auto *server = new QTcpServer(this);\nconnect(server, &QTcpServer::newConnection, this, [server] {\n    while (server->hasPendingConnections()) {\n        auto *client = server->nextPendingConnection(); // server 暂时拥有\n        connect(client, &QTcpSocket::readyRead, this, [client] {\n            appendAndParse(client, client->readAll()); // TCP 字节流\n        });\n        connect(client, &QTcpSocket::disconnected, client, &QObject::deleteLater);\n    }\n});\nif (!server->listen(QHostAddress::Any, port)) report(server->errorString());\n// 限制每连接缓冲与消息长度", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("026  如何使用Qt实现HTTP请求？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  创建并复用 QNetworkAccessManager，以 get(QNetworkRequest(url)) 或 post(request, body) 异步发送请求；给 QNetworkReply 接 finished/errorOccurred 槽，读取状态码、头部和响应体后 deleteLater()。请求头可设 Content-Type、认证信息，HTTPS 需验证证书；不要在 GUI 线程调用 waitFor... 阻塞等待。", size: 9.5pt)
  #raw("auto *manager = new QNetworkAccessManager(this);\nauto *reply = manager->post(QNetworkRequest(QUrl(url)), body);\nconnect(reply, &QNetworkReply::finished, this, [reply] {\n    if (reply->error() != QNetworkReply::NoError) report(reply->errorString());\n    else if (reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt() >= 400)\n        reportHttpStatus(reply->attribute(QNetworkRequest::HttpStatusCodeAttribute));\n    else consume(reply->readAll());\n    reply->deleteLater();\n});\n// GUI 线程不要 waitFor...；HTTPS 必须验证证书", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("027  如何使用Qt操作SQLite数据库？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  确保部署了 Qt SQL 的 SQLite 驱动插件，建立命名 QSQLITE 连接并设置数据库文件路径；open() 成功后使用 QSqlQuery 的 prepare()/bindValue() 执行参数化语句，避免拼接用户输入。读多行要检查 exec()/next() 与 lastError()；关闭连接前销毁 query 和 model，数据库操作保持在连接所属线程。", size: 9.5pt)
  #raw("const QString connection = QUuid::createUuid().toString();\n{\n    QSqlDatabase db = QSqlDatabase::addDatabase(QStringLiteral(\"QSQLITE\"), connection);\n    db.setDatabaseName(filePath);\n    if (!db.open()) return report(db.lastError());\n    QSqlQuery query(db); query.prepare(QStringLiteral(\"INSERT INTO user(name) VALUES(?)\"));\n    query.addBindValue(userName); if (!query.exec()) report(query.lastError());\n} // 先析构 query/model/db 副本\nQSqlDatabase::removeDatabase(connection); // 部署也要包含 QSQLITE 驱动", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("028  如何处理网络数据的粘包和拆包？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  TCP 只提供连续字节流，readyRead() 一次可能收到半包或多包，因此把 readAll() 追加到缓冲区后按协议循环解析。常用固定头部长度前缀方案：先等够头部，解出长度并检查上限，再等完整 payload；分隔符协议需处理转义或内容编码，不能假设一次 read 就是一条消息。长度字段要固定字节序并防整数溢出，处理完成后从缓冲区移除对应完整帧。", size: 9.5pt)
  #raw("buffer.append(socket->readAll()); // readyRead 一次可能含半帧或多帧\nwhile (buffer.size() >= 4) {\n    const auto *head = reinterpret_cast<const uchar *>(buffer.constData());\n    const quint32 length = qFromBigEndian<quint32>(head); // 固定大端长度\n    if (length > maxPayload || length > std::numeric_limits<quint32>::max() - 4u) { socket->abort(); return; }\n    if (buffer.size() < 4 + length) break; // 半帧留待下次数据\n    handle(buffer.mid(4, length)); buffer.remove(0, 4 + length);\n}\n// 解析后移除完整包；长度上限避免溢出和内存耗尽", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("029  如何实现数据库的事务处理？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  确认当前 QSqlDriver 支持事务后调用 db.transaction()，用多个 QSqlQuery 完成一组变更并逐条检查结果；全成功才 commit()，任一步失败就 rollback()。事务应尽量短，并检查提交本身的返回值；事务只保证数据库操作原子性，不自动解决业务层重试、并发冲突或外部服务副作用。", size: 9.5pt)
  #raw("if (!db.transaction()) return report(db.lastError());\nbool ok = false; QSqlError queryError;\n{ QSqlQuery q(db); q.prepare(sql); q.addBindValue(value);\n  ok = q.exec(); if (!ok) queryError = q.lastError(); }\nif (!ok) { db.rollback(); return report(queryError); } // query 先销毁\nif (!db.commit()) { const auto error = db.lastError(); db.rollback(); report(error); }\n// 事务尽量短；外部服务副作用不由数据库回滚", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("030  如何自定义 Model？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  列表模型优先继承 QAbstractListModel，实现 rowCount() 和 data()；表格模型再实现 columnCount()，编辑功能加 flags()、setData() 并在修改后发 dataChanged。插入、删除、重置前后必须配对调用 beginInsertRows/endInsertRows 等 API，索引由 model 创建和解释，树模型还须正确实现 index()、parent()。", size: 9.5pt)
  #raw("bool Model::insertRows(int row, int count, const QModelIndex &parent) {\n    if (parent.isValid() || count <= 0 || row < 0 || row > rows_.size()) return false;\n    beginInsertRows(parent, row, row + count - 1); // 先通知视图\n    rows_.insert(row, count, Item{});\n    endInsertRows(); // 修改后闭合通知\n    return true;\n}\nQVariant Model::data(const QModelIndex &i, int role) const { /* bounds + role */ }\n// 修改已有值后发 dataChanged；移除也用 begin/endRemoveRows", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("14.5 高级特性与 QML", size: 14pt, weight: "bold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  Loader、Repeater、ListView 的作用是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Loader 根据 source 或 sourceComponent 动态创建一段 QML 子树，适合延迟打开低频页面；切换 source 会销毁旧对象，使用前检查 status/item。Repeater 会一次为模型每项创建 delegate，适合数量较小的固定集合；ListView 按可视区域创建并可复用 delegate，更适合长列表，模型数据应独立于 delegate 生命周期。", size: 9.5pt)
  #raw("// QML：Loader 仅在需要时创建低频页面\nLoader { id: settings; active: settingsVisible; source: \"Settings.qml\" }\nonLoaded: settings.item.resetView()\nonStatusChanged: if (status === Loader.Error) console.warn(errorString())\n// Repeater 会为所有项创建 delegate，适合小集合\nRepeater { model: 5; delegate: Text { text: index } }\n// 长列表用 ListView 的可视 delegate；model 状态不能放在会销毁的 delegate 内", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  QLibrary 的作用是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QLibrary 在运行时打开普通动态库，用 load() 加载、resolve(\"functionName\") 取得导出函数地址，结束后 unload()；返回指针要匹配准确 ABI、调用约定和函数签名。库文件名及依赖按平台部署，加载失败应记录 errorString()；需要 Qt 插件元数据、接口检查和 QObject 实例时应使用 QPluginLoader。", size: 9.5pt)
  #raw("QLibrary library(fileName);\nif (!library.load()) return report(library.errorString());\nusing CreateFn = QObject *(*)(); // 导出函数 ABI 必须一致\nauto create = reinterpret_cast<CreateFn>(library.resolve(\"createPlugin\"));\nif (!create) return report(library.errorString());\nQObject *instance = create(); // 调用期间库必须仍加载\nuse(instance);\ndestroyWithLibraryContract(instance);\nlibrary.unload(); // 所有函数指针/对象失效后才卸载", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  QML 中如何实现动画效果？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QML 可用 NumberAnimation、ColorAnimation 或 PropertyAnimation 改变属性，写在 Behavior 中可响应值变化，也可由 states/Transition 驱动状态切换。例：给 opacity 配 200ms 动画并用 easing 控制曲线；动画期间避免另一段逻辑持续覆盖同一属性，循环动画需设置明确的停止条件。", size: 9.5pt)
  #raw("// QML\nRectangle {\n    id: panel\n    opacity: expanded ? 1.0 : 0.0\n    Behavior on opacity {\n        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }\n    }\n}\n// 状态切换也可由 states/Transition 驱动\n// 多个动画不要同时命令式写同一属性；隐藏组件时停止循环动画", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  QML 中的信号和槽如何使用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QML 组件用 signal valueChosen(int value) 声明信号，用 onValueChosen: ... 处理本组件信号，也可通过 Connections 监听动态目标。C++ 端 QObject 信号可连接 QML handler，QML 信号也能由 C++ connect；参数类型须可由 QML 元类型系统识别，处理长任务时不要阻塞界面线程。", size: 9.5pt)
  #raw("// QML\nItem {\n    signal valueChosen(int value)\n    Button { onClicked: valueChosen(7) }\n    onValueChosen: console.log(\"chosen\", value)\n}\n// C++ 接 QObject 信号时用 typed connect\nconnect(&backend, &Backend::finished, this, &Window::showResult);\n// QML 参数需可被元类型系统识别；重活不能同步阻塞 UI", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  QML 中的属性绑定是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  属性绑定是表达式依赖：如 width: parent.width * 0.5，依赖值变化时引擎重新计算并更新属性，适合把布局和状态关系写清楚。若随后用命令式赋值直接写 width，原绑定通常会被移除；需要恢复时使用 Qt.binding()，表达式应保持纯计算，避免副作用造成重复执行。必要时可用 qmllint 检查绑定断裂和未限定属性引用，减少运行时才出现的问题。", size: 9.5pt)
  #raw("// QML 属性绑定会跟踪 parent.width 变化\nRectangle { width: parent.width * 0.5 }\n// 直接赋值通常会移除原绑定\ntarget.width = 240\n// 需要重新绑定时显式恢复表达式\ntarget.width = Qt.binding(function() { return parent.width * 0.5 })\n// 绑定应是无副作用计算；工具可检查绑定被意外打断", lang: "qml", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  QML 和 C++ 如何交互？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  用 QObject 子类向 QML 暴露 Q_PROPERTY、信号、槽和 Q_INVOKABLE，再按需通过 qmlRegisterType/QML_ELEMENT 注册类型或提供实例。上下文属性虽方便但依赖不显式、工具难分析；优先考虑注册类型或根对象属性。明确 C++ 对象仍由谁持有，QML 引擎对方法返回 QObject 的所有权规则需特别检查。", size: 9.5pt)
  #raw("class Backend : public QObject {\n    Q_OBJECT\n    Q_PROPERTY(QString title READ title NOTIFY titleChanged)\npublic:\n    Q_INVOKABLE void refresh() { /* 异步触发工作 */ }\nsignals: void titleChanged();\n};\nqmlRegisterType<Backend>(\"App\", 1, 0, \"Backend\"); // 类型可见\n// QML 引擎使用对象时确认 QObject owner 与销毁顺序", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("007  Q_INVOKABLE 宏的作用是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Q_INVOKABLE 把成员函数写入元对象信息，可经 QMetaObject::invokeMethod() 按名称调用，也可让 QML 调用该方法；所在类须继承 QObject 并带 Q_OBJECT。它适合简单命令或查询，不应把耗时工作直接同步暴露给 QML，否则会卡住对应线程；参数和返回类型须能被元对象系统处理。", size: 9.5pt)
  #raw("class Backend : public QObject {\n    Q_OBJECT\npublic:\n    Q_INVOKABLE QString greeting(const QString &name) const {\n        return tr(\"Hello, %1\").arg(name);\n    }\n};\nQMetaObject::invokeMethod(&backend, \"refresh\", Qt::QueuedConnection);\n// Q_INVOKABLE 写入元对象；同步耗时函数会卡住调用线程", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("008  Q_PROPERTY 宏的作用是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Q_PROPERTY 在 QObject 子类中声明可反射访问的静态属性，例如 Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)，供 QML、Designer 和元对象 API 使用。写入值变化时发出 NOTIFY 信号，QML 绑定才会重新计算；属性读写函数和通知应对应同一状态，勿只把成员变量列出来却不维护一致性。", size: 9.5pt)
  #raw("class Backend : public QObject {\n    Q_OBJECT\n    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)\npublic:\n    QString title() const { return title_; }\n    void setTitle(const QString &v) { if (title_ == v) return; title_ = v; emit titleChanged(); }\nsignals: void titleChanged();\nprivate: QString title_;\n};\n// NOTIFY 触发 QML 绑定更新；属性读写必须共享同一状态", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("009  Qt Widgets 与 Qt Quick/QML 如何选择？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Qt Widgets 提供成熟桌面控件和原生风格集成，适合表单、传统工具和大量既有 QWidget 代码；Qt Quick/QML 用声明式层次、属性绑定和动画，适合触控、动态视觉界面。也可混合使用：QML 构建外观，C++ 提供模型和业务逻辑；选型还要考虑平台、团队经验与模块部署。Widgets 和 Quick 可以通过容器桥接混用，但跨界会增加事件、样式和构建复杂度。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("010  Qt 中如何实现动态库的加载？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  普通 C ABI 动态库用 QLibrary 加载并 resolve 导出函数；Qt 插件则由共享库实现稳定接口，接口用 Q_DECLARE_INTERFACE 声明、插件类用 Q_PLUGIN_METADATA 导出，再由 QPluginLoader::instance() 取对象并 qobject_cast 校验。插件必须与宿主的 Qt/编译器 ABI、接口版本和部署目录兼容，释放实例前不能卸载库。", size: 9.5pt)
  #raw("// 普通 C ABI 用 QLibrary；Qt 插件更适合 QPluginLoader\nQPluginLoader loader(pluginPath);\nQObject *object = loader.instance();\nif (!object) return report(loader.errorString());\nauto *plugin = qobject_cast<MyInterface *>(object);\nif (!plugin) return report(QStringLiteral(\"interface mismatch\"));\nplugin->start();\n// 销毁插件对象及其调用者后才能卸载库；宿主/插件 ABI 必须匹配", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("011  Qt 中如何实现属性系统？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  静态属性在类中以 Q_PROPERTY 声明并由 moc 记录；运行时通过 QObject::property()/setProperty() 按名称访问。名称未声明为静态属性时，setProperty() 可附加动态属性，适合临时标记或 QSS 属性选择器；静态属性写入仍遵循 WRITE/read-only 规则，不能因为使用反射就绕过类型和线程约束。", size: 9.5pt)
  #raw("// 静态属性在 QObject 子类中用 Q_PROPERTY + moc 声明\nQ_PROPERTY(int count READ count WRITE setCount NOTIFY countChanged)\nobject->setProperty(\"count\", 3); // 走静态属性的 WRITE\nobject->setProperty(\"busy\", true); // 未声明时添加动态属性\nconst QVariant busy = object->property(\"busy\");\n// 动态属性无强类型访问器和专属 NOTIFY\n// 常驻业务状态优先声明静态属性", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("012  Qt 的反射机制是如何实现的？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Qt 元对象系统由 moc 在构建阶段为含 Q_OBJECT 的类生成表格元信息，支持信号槽、属性、类名查询和 invokeMethod 等运行时能力。它解决的是 Qt 对象层需要的有限反射，不会自动枚举任意 C++ 成员或模板；构建系统需启用 AUTOMOC，普通 C++ 反射需求仍需其他机制或显式注册。", size: 9.5pt)
  #raw("class Device : public QObject {\n    Q_OBJECT\n    Q_PROPERTY(QString name READ name)\npublic slots: void start() { /* ... */ }\n};\nconst QMetaObject *meta = device->metaObject(); // moc 生成元数据\nint propertyIndex = meta->indexOfProperty(\"name\");\nint methodIndex = meta->indexOfMethod(\"start()\");\nQMetaObject::invokeMethod(device, \"start\", Qt::QueuedConnection);\n// 这套反射不会自动枚举任意 C++ 成员；构建启用 AUTOMOC", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("013  Qt 的对象序列化如何实现？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Qt 没有自动把任意 QObject 实例及其属性完整持久化的通用序列化器；通常显式选取字段，用 QDataStream 自定义 operator<< / >>，或转成 QVariantMap/QJsonObject 再保存。读写双方要约定格式版本、默认值和兼容策略；QObject 的指针、父子树和信号连接不会因写出属性而自动恢复。", size: 9.5pt)
  #raw("QJsonObject record{{\"version\", 2}, {\"name\", object.name()}};\nconst QByteArray bytes = QJsonDocument(record).toJson(QJsonDocument::Compact);\nQFile file(path); if (!file.open(QIODevice::WriteOnly)) return report(file.errorString());\nif (file.write(bytes) != bytes.size()) return report(file.errorString());\nQJsonParseError error; const auto doc = QJsonDocument::fromJson(file.readAll(), &error);\nif (error.error != QJsonParseError::NoError) return report(error.errorString());\nrestoreFields(doc.object()); // QObject 指针树/连接不会由属性自动恢复\n// 长文档和兼容格式需限制大小并显式迁移 version", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("014  Qt 的插件机制是什么？如何实现插件？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  插件提供者先定义版本化纯虚接口，宿主和插件共享接口头文件；插件实现 QObject 类、使用 Q_OBJECT 与 Q_PLUGIN_METADATA，接口用 Q_DECLARE_INTERFACE 标记。宿主遍历插件目录，用 QPluginLoader 加载、检查 errorString() 并 qobject_cast；插件实例销毁前不得 unload，且部署要匹配 Qt 次版本、编译器 ABI 和依赖。", size: 9.5pt)
  #raw("QPluginLoader loader(pluginPath);\nQObject *root = loader.instance(); // loader 持有库和根对象\nif (!root) return report(loader.errorString());\nauto *iface = qobject_cast<MyInterface *>(root); // 检查接口\nif (!iface) return report(QStringLiteral(\"unsupported plugin\"));\niface->initialize();\nconnect(this, &Host::closing, root, &Plugin::stop);\n// 停止调用者并销毁对象后才 unload；检查版本和 ABI", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("015  动态属性（Dynamic Property）是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  动态属性是在运行时通过 setProperty(\"busy\", true) 附加到 QObject 的名称和值，不需在类源码中预先定义，可用 property() 查询或传给基于属性选择器的 QSS。它不自动提供强类型访问器或属性专属 NOTIFY 信号，属性变化会产生 QDynamicPropertyChangeEvent；常驻业务状态更适合声明 Q_PROPERTY。", size: 9.5pt)
  #raw("widget->setProperty(\"busy\", true); // 运行时附加属性\nconst QVariant value = widget->property(\"busy\");\nif (!value.isValid()) return; // 检查属性是否存在\napplyBusyStyle(value.toBool());\nconnect(widget, &QObject::destroyed, this, &Controller::clearState);\n// 动态属性变化还会产生 QDynamicPropertyChangeEvent\n// 常驻业务状态改用有类型访问器的 Q_PROPERTY", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("14.6 工程实践", size: 14pt, weight: "bold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  .pro 文件的作用是什么？常用配置有哪些？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  .pro 是 qmake 项目描述文件，告诉构建系统生成应用、库还是子项目，并枚举源文件、模块、宏和链接依赖。常见项有 TEMPLATE、QT、SOURCES、HEADERS、CONFIG、INCLUDEPATH、LIBS；例如加入 network 模块后还要链接对应 Qt 库。Qt 6 仍可构建 qmake 项目，新项目也可按团队工具链采用 CMake。", size: 9.5pt)
  #raw("TEMPLATE = app\nQT += widgets network sql\nCONFIG += c++20\nSOURCES += main.cpp worker.cpp\nHEADERS += worker.h\nFORMS += mainwindow.ui\n# qmake 从 .pro 生成构建文件；CMake 项目改用 Qt6::Widgets 等 targets", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  C++11 / 14 / 17 / 20 的新特性在 Qt 中如何应用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  现代 C++ 能简化 Qt 代码：C++11 的 lambda 常用于 connect，智能指针和移动语义改善所有权；C++17 的结构化绑定、std::optional 可用于数据接口，C++20 协程可与合适异步库结合。Qt 版本与编译器决定可用标准和 Qt API，标准语言特性不等于 Qt 自动支持协程，构建时应显式设置 CXX_STANDARD。", size: 9.5pt)
  #raw("connect(button, &QPushButton::clicked, this, [this, id = record.id] {\n    saveRecord(id); // lambda 按值捕获异步所需数据\n});\nstd::optional<Result> result = findResult(id); // C++17 接口可表达缺失值\nif (result) show(*result);\n// CXX_STANDARD 由项目工具链显式设置；语言标准不等于 Qt API 版本", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  Lambda 表达式在 Qt 信号槽中如何使用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  新式 connect 可直接把信号连接到 lambda，例如 connect(button, &QPushButton::clicked, this, [this]{ save(); });，上下文对象销毁时连接会断开。捕获局部变量按值保存或确保引用在连接期内有效；长生命周期异步回调需防止访问已释放对象，简单逻辑适用 lambda，复杂业务仍宜拆到具名槽。", size: 9.5pt)
  #raw("connect(button, &QPushButton::clicked, this, [this, recordId] {\n    save(recordId); // context 销毁时连接自动断开\n});\nconst auto connection = connect(source, &Source::ready, this,\n    [this](const Result &r) { show(r); });\ndisconnect(connection); // 动态连接可保存句柄\n// 引用捕获的局部变量必须活到回调结束；复杂逻辑放具名槽", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  MVC、MVP、MVVM 在 Qt 中如何应用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  MVC 把数据、显示和输入协调分开，Qt 的 Model/View/Delegate 是数据视图领域的成熟实现；MVP 由 Presenter 作为中介调用 View 接口，便于测试。MVVM 让 ViewModel 暴露可绑定状态，适合 QML 属性绑定，但它不是 Qt 强制架构；根据界面复杂度和测试边界选取，避免为简单页面套多层抽象。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  Qt 5 和 Qt 6 有什么主要区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Qt 6 延续大量 Qt 5 API，但提高了工具链要求、重整图形栈与部分模块，QList/QVector 的实现关系也变了；Qt 6 工程通常以 CMake 作为主流构建选择。迁移应对照目标小版本的 Porting Guide，检查已移除模块、重命名或行为变化、信号签名和部署插件，并在实际目标平台编译运行。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  Qt 6 中移除了哪些模块？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Qt 6 移除了 Qt Script、Qt XmlPatterns、Qt Quick Controls 1 等旧模块，Qt WebKit 不再随 Qt 提供且 WebEngine 不是源码级等价替换；Qt State Machine 等内容也调整了模块归属。Qt Multimedia 接口经过重做，不能简单归为整个模块移除；迁移时按目标小版本官方清单确认替代 API 和兼容层。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("007  Qt 6 的新特性有哪些？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Qt 6 用 RHI 抽象 Qt Quick 图形后端，使场景可使用 Vulkan、Metal、Direct3D 或 OpenGL 等后端，具体可用性由平台和构建决定；还更新了 QML 工具链、模块化和高 DPI 行为。它不是保证所有设备都自动加速，应用需验证渲染后端、驱动、着色器与目标硬件兼容性。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("008  Qt Creator 的使用技巧有哪些？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Qt Creator 中可用 Kits 管理 Qt 版本、编译器、调试器和目标设备，先确认 Kit 匹配再构建；代码导航、符号搜索和安全重构能减少手动查找。调试时查看调用栈、线程和局部变量，必要时给 Qt/应用配置符号；Designer 用于编辑 .ui，性能分析则应使用 profiler 找到热点再优化。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("009  Qt Test 框架是什么？如何使用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Qt Test 是随 Qt 提供的单元测试框架，测试类继承 QObject，在 private slots 中写 initTestCase、测试函数和清理函数，用 QVERIFY/QCOMPARE 断言。由 QTEST_MAIN 或 QTEST_GUILESS_MAIN 提供入口，CMake 链接 Qt::Test 后可在 CI 运行；测试优先覆盖业务逻辑，GUI 行为可用 QTest 鼠标键盘事件验证。", size: 9.5pt)
  #raw("class ModelTest : public QObject {\n    Q_OBJECT\nprivate slots:\n    void rowCountIsUpdated() {\n        TaskModel model; QCOMPARE(model.rowCount(), 0);\n        model.append(Task{QStringLiteral(\"one\")});\n        QCOMPARE(model.rowCount(), 1);\n    }\n};\nQTEST_GUILESS_MAIN(ModelTest) // CMake target_link_libraries(... Qt6::Test)\n// GUI 交互可用 QTest::mouseClick；外部依赖要用 fake 隔离", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("010  Qt 中如何调用平台特定的 API？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  跨平台功能优先调用 Qt API；确需原生能力时按 Q_OS_WIN、Q_OS_LINUX 等宏隔离代码，并将系统调用封装在平台适配层。窗口句柄或原生接口可能随平台后端、窗口生命周期和高 DPI 改变，使用前检查文档和返回值；让通用业务层不依赖平台头文件，便于其他平台构建。若要跨线程访问原生句柄，还需遵守操作系统线程与窗口有效期要求。", size: 9.5pt)
  #raw("QWindow *window = /* 已创建的平台窗口 */;\n#ifdef Q_OS_WIN\n    const WId handle = window->winId(); // 仅在平台适配层调用原生 API\n    useWin32Handle(handle);\n#elif defined(Q_OS_MACOS)\n    useCocoaWindow(window->winId());\n#else\n    usePortableQtPath(window);\n#endif\n// 检查句柄有效期/DPI；平台头文件不要泄漏到业务层", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("011  Qt 中有哪些调试工具？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  定位问题时先用 Qt Creator 或 GDB/LLDB 查看断点、调用栈与线程；qDebug/qWarning 可补充运行日志，Qt Test 回归具体行为。内存问题用 ASan/LSan 或 Valgrind，性能用采样 profiler/QElapsedTimer；发布环境应保留符号化崩溃栈，日志不得泄露口令和令牌。", size: 9.5pt)
  #raw("QElapsedTimer timer; timer.start();\nrunRepresentativeOperation();\nqInfo() << \"operation ms\" << timer.elapsed(); // 局部测量而非结论\n// Qt Creator Profiler/GDB 看调用栈、线程、CPU 热点\n// ASan/LSan 或 Valgrind 查内存；发布包保留匹配符号\n// 用同一 Release 配置、同一输入复测改动前后", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("012  Qt 如何实现跨平台？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Qt 通过平台抽象层和插件封装窗口系统、输入、文件与网络等差异，让同一套 API 在多个系统构建；Widgets 的平台插件会接入 Windows、Cocoa、X11 或 Wayland 等后端。跨平台不等于行为完全一致，字体、路径权限、屏幕坐标、编码和打包插件仍需目标平台测试，平台专属功能要隔离实现。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("013  Qt 应用出现内存泄漏如何定位和处理？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  用 ASan/LSan、Valgrind 或系统堆分析器重现并记录分配栈，区分真正泄漏、仍可达缓存和延迟释放。检查未纳入 QObject 父子树的裸指针、shared_ptr 环、定时器与 lambda 捕获、重复创建资源；修复时明确单一所有者或 RAII，反复打开关闭页面并检查退出路径。", size: 9.5pt)
  #raw("QPointer<Worker> worker = page->worker(); // 观察 QObject 是否仍存活\nconnect(worker, &Worker::done, this, [worker] {\n    if (!worker) return; // 异步时对象可能已销毁\n    consume(worker->result());\n});\npage->close(); // 父子树回收其子对象\n// 用 sanitizer/堆快照定位孤儿对象、环和重复创建资源\n// 修复后反复打开关闭页面并检查退出路径", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("014  Qt 界面如何实现国际化和运行时切换？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  用户可见文本用 tr() 标记，lupdate 提取到 .ts，译者在 Qt Linguist 编辑后用 lrelease 生成 .qm；运行时加载 QTranslator 并 installTranslator()。切换语言要重新执行控件 retranslateUi()/刷新模型展示文本，还需考虑复数、动态拼接文本和长词造成的布局变化；安装顺序影响翻译查找。", size: 9.5pt)
  #raw("QTranslator translator; // 生命周期覆盖应用翻译期间\nif (!translator.load(locale, QStringLiteral(\":/i18n/app\"))) reportLoadError();\nqApp->installTranslator(&translator);\nui->retranslateUi(window); // Designer 控件刷新\nmodel->refreshTranslatedLabels(); // 自定义模型文本也需重算\n// 用户文案统一 tr()；复数用 n 参数，不拼接词片段\n// 长词会改变布局，应检查窄窗口和切换时机", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("015  Qt 程序崩溃的常见原因有哪些？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  常见崩溃源包括空/悬空指针、越界、重复释放、对象树错误、跨线程访问 QWidget，以及异步槽或 lambda 使用已销毁对象。第三方库 ABI 不匹配、资源插件缺失也会导致启动或调用失败；用符号栈和 sanitizer 将故障定位到实际访问点，并检查关闭窗口、取消任务等生命周期边界。保留最小可复现输入和精确二进制版本，便于把偶发故障关联到符号栈。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("016  qDebug()、qWarning()、qCritical() 有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  qDebug 用于诊断信息，qInfo 表示一般运行信息，qWarning 提醒可恢复异常，qCritical 表示严重错误；qFatal 输出后会终止进程。日志级别本身不自动保证问题处理，程序仍要检查错误返回值；可通过 QT_NO_DEBUG_OUTPUT 等构建配置关闭调试输出，生产日志需设置滚动和隐私策略。", size: 9.5pt)
  #raw("qDebug() << \"cache miss\" << key; // 诊断细节\nqInfo() << \"service started\"; // 运行信息\nqWarning() << \"retrying\" << error; // 可恢复问题\nqCritical() << \"database unavailable\"; // 严重错误仍需明确处理\nif (!query.exec()) handle(query.lastError()); // 日志等级不代替错误检查\n// qFatal 会终止进程；生产日志需轮转并脱敏", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("017  qmake 和 CMake 有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  qmake 用 .pro 描述 Qt 工程，Qt 集成直接、旧项目常见；CMake 是通用构建系统，Qt 6 官方文档主推其 imported targets、AUTOMOC/AUTOUIC/AUTORCC 与跨项目生态。两者都能构建 Qt 项目，选择应看依赖和团队工具；迁移时将 Qt 模块、资源和代码生成规则逐项映射，不只是改文件名。", size: 9.5pt)
  #raw("cmake_minimum_required(VERSION 3.21)\nproject(App LANGUAGES CXX)\nset(CMAKE_AUTOMOC ON)\nset(CMAKE_AUTOUIC ON)\nfind_package(Qt6 REQUIRED COMPONENTS Widgets Network)\nadd_executable(app main.cpp window.cpp window.ui)\ntarget_link_libraries(app PRIVATE Qt6::Widgets Qt6::Network)\n# 旧 qmake 工程把模块/资源/uic 规则逐项映射再迁移", lang: "cmake", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("018  windeployqt 和 macdeployqt 的作用是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  windeployqt 收集 Windows 运行所需的 Qt DLL、插件和 QML 依赖；macdeployqt 把相关库与插件放入 .app 并修整部分库路径。它们不能自动发现全部第三方依赖或替代签名、公证；部署后在未安装 Qt 的干净环境启动，检查平台插件、翻译、图片格式和多媒体后端。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("019  不同平台下 Qt 程序的打包和部署有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Windows 常随程序部署 DLL 和 plugins/platforms；macOS 要维护 .app 内框架路径、代码签名和公证；Linux 则要面对发行版 ABI、系统库与平台插件版本。对应部署工具能复制一部分依赖，不能覆盖所有运行环境差异；在目标 OS/架构的干净机器测试安装、升级和卸载流程。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("020  信号槽连接失败的常见原因有哪些？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先检查 connect() 是否成功、信号槽签名和参数类型是否兼容；旧式字符串连接容易因拼写或 const/reference 差异失败，新式函数指针连接更能编译期报错。自定义信号需 QObject 派生并有 Q_OBJECT、构建时 moc 正常运行；跨线程槽要有接收线程事件循环，连接对象也须仍存活。", size: 9.5pt)
  #raw("const auto connection = QObject::connect(\n    sender, &Sender::ready, receiver, &Receiver::consume);\nif (!connection) qWarning() << \"connect failed\"; // 新式签名编译期检查\n// 跨线程队列槽依赖接收者事件循环\n// 自定义信号类需要 QObject + Q_OBJECT + 正常 moc\n// 重复初始化要么只连接一次，要么保存句柄按需断开", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("021  大量数据显示时如何优化性能？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  大数据视图用 QAbstractItemModel 配 QListView/QTableView，配合 Delegate 绘制可见项，避免为每行创建数千个 QWidget；耗时数据可用 canFetchMore()/fetchMore() 分批载入。批量修改时成组发模型通知、合并 UI 刷新，并测量 data()/paint() 热点；缓存需有上限且数据变化时失效。", size: 9.5pt)
  #raw("bool Model::canFetchMore(const QModelIndex &parent) const {\n    return !parent.isValid() && loaded_ < total_;\n}\nvoid Model::fetchMore(const QModelIndex &parent) {\n    const int count = qMin(batchSize, total_ - loaded_);\n    beginInsertRows(parent, loaded_, loaded_ + count - 1);\n    loadNextBatch(count); loaded_ += count; endInsertRows();\n}\n// delegate 绘制可见行；缓存必须设上限并在数据改变时失效", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("022  如何优化 Qt 应用程序的启动速度？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先用启动剖析记录耗时，再推迟非首屏模块、缩略图和网络请求，减少 main() 里的同步 I/O；可用 Loader 延后实例化 QML 页面，并把独立初始化放后台。资源系统主要改善资源组织与读取部署，不会自动减少加载时间；优先加载用户立即需要的内容并报告异步进度。通过预热、延迟和并行初始化需分别测量首屏时间与总启动时间，不能只看其中一个。", size: 9.5pt)
  #raw("// QML：首页先显示，低频页面延后构造\nApplicationWindow {\n    Component.onCompleted: Qt.callLater(() => settingsLoader.active = true)\n    Loader { id: settingsLoader; active: false; source: \"Settings.qml\" }\n}\n// 网络与磁盘初始化异步执行，首屏只载入必要资源\n// 分别测首屏时间与全部启动时间，延迟加载不一定缩短总耗时", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("023  如何优化 Qt 界面的绘制性能？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先用 profiler 确认是 CPU 绘制、布局还是数据更新造成重绘；随后缩小 update() 区域、缓存静态层、避免 paintEvent 做 I/O 或复杂计算，并减少每帧创建临时对象。列表采用 Model/View 和 delegate 虚拟化；Qt Quick 图形后端是否加速依平台而定，要以目标设备测帧率和内存。", size: 9.5pt)
  #raw("void Chart::setPoint(const QPointF &p) {\n    const QRect dirty = markerRect_ | nextMarkerRect(p);\n    marker_ = p; markerRect_ = nextMarkerRect(p);\n    update(dirty); // 仅请求局部重绘\n}\nvoid Chart::paintEvent(QPaintEvent *e) {\n    QPainter painter(this); painter.setClipRegion(e->region());\n    drawCachedGrid(painter); drawMarker(painter, marker_);\n}\n// 不在 paintEvent 做 I/O/复杂计算；Model/View 可虚拟化大列表", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("024  如何减小 Qt 程序的体积？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  使用 Release 优化构建并去除符号文件，移除未使用 Qt 模块、插件、翻译和大资源，再检查依赖闭包；平台部署工具可按实际使用裁剪插件。静态链接常让单文件变大且不自动消除依赖，还需处理静态插件注册和许可证义务；比较安装包而非只看主可执行文件。不同平台可用 strip 或符号分离工具，但需留存对应符号以支持线上诊断。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("025  如何减少 Qt 应用程序的内存占用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  通过 profiler 和堆快照找出高水位来自图像、缓存、模型还是泄漏；限制队列与缓存容量，按目标尺寸解码图片，及时释放不再显示的临时数据。QObject 用父子关系明确生命周期，普通资源用 RAII；隐式共享有助减少副本但修改可能触发分离，避免无依据地反复 squeeze 容器。高分辨率图片可先生成缩略图，避免同时保留多个全尺寸 QPixmap。", size: 9.5pt)
  #raw("QImageReader reader(path);\nreader.setScaledSize(targetPixels); // 按目标显示尺寸解码\nQImage thumbnail = reader.read();\nif (thumbnail.isNull()) return report(reader.errorString());\ncache.insert(key, thumbnail); // 缓存设置最大容量和淘汰策略\nif (cache.size() > maxEntries) evictOldest();\nthumbnail = {}; // 不再显示时释放引用\n// 隐式共享能减副本，写操作仍可能触发 detach", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("026  如何分析 Qt 应用程序的性能瓶颈？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  在代表性场景下用 Qt Creator Profiler 或系统采样器定位 CPU、内存、QML 和渲染热点，先记录基线；QElapsedTimer 可量测局部关键路径，但不要把单次测量当结论。检查主线程阻塞、频繁布局/重绘和网络等待，针对最热环节改动后用相同输入复测。避免用 Debug 构建测量发布性能，编译优化和符号设置会显著改变结果。", size: 9.5pt)
  #raw("QElapsedTimer timer; timer.start();\nconst auto result = runHotPath(input);\nconst qint64 elapsedMs = timer.elapsed();\nqInfo() << \"hot path ms\" << elapsedMs; // 测真实路径\n// profiler 先找 CPU/内存/渲染热点，不凭猜测优化\n// 改动后用相同 Release 构建、设备和输入复测\n// 单次耗时会受调度影响，应重复采样", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("027  如何处理不同平台的路径分隔符问题？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  路径拼接和遍历用 QDir、QFileInfo、QFile 等 API，避免手工拼接 Windows 的反斜杠；Qt 通常接受正斜杠作为跨平台路径分隔符。用户输入路径要规范化并验证根目录边界，不能仅靠 cleanPath() 防止路径穿越；区分文件系统路径、URL 和资源路径 :/。处理外部不可信路径时还应防止软链接和符号链接绕出允许目录。", size: 9.5pt)
  #raw("QDir root(allowedRoot);\nconst QString candidate = root.filePath(userRelativePath); // 不手拼斜杠\nconst QString clean = QDir::cleanPath(candidate);\nif (!isWithinAllowedRoot(clean, root.absolutePath())) return reject();\nQFile file(clean);\nif (!file.open(QIODevice::ReadOnly)) return report(file.errorString());\nconsume(file.readAll());\n// cleanPath 不阻止软链接逃逸；边界校验按真实文件系统路径做", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("028  如何实现 Qt 应用程序的单例模式？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  若确实需要进程内唯一服务，可将构造函数私有、禁用拷贝并提供 instance()，由 C++11 静态局部初始化保证线程安全。QObject 单例应在 QApplication 创建后再实例化，并避免再交给另一父对象或智能指针重复释放；多数可替代服务可由应用对象持有并依赖注入，降低全局耦合。", size: 9.5pt)
  #raw("class Service : public QObject {\n    Q_OBJECT\npublic:\n    static Service &instance() { static Service value; return value; }\n    Service(const Service &) = delete;\n    Service &operator=(const Service &) = delete;\nprivate:\n    Service() = default; // 不交给另一个 parent/shared_ptr 重复拥有\n};\n// 首次调用应在 QApplication 构造之后；优先考虑依赖注入", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("029  如何实现 Qt 应用程序的崩溃捕获和日志记录？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  普通错误应通过异常/错误码和 Qt 日志处理；崩溃时优先配置系统 core dump、Windows minidump 或崩溃收集器保存符号化栈和版本信息。SIGSEGV 等致命信号处理器中不能安全调用 QFile、qDebug 或分配内存，通常不可恢复继续运行；可记录最少信号信息后交给平台崩溃机制。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("030  如何实现 Qt 应用程序的日志系统？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  用 qDebug/qInfo/qWarning 等按级别记录，通过 qInstallMessageHandler() 集中添加时间、线程 ID、分类并写入滚动文件；处理器可能由多个线程并发调用，写文件需同步。handler 内避免再次调用 Qt 日志以免递归，也不应阻塞主线程做网络上传；敏感字段应脱敏。", size: 9.5pt)
  #raw("static QMutex logMutex;\nvoid messageHandler(QtMsgType type, const QMessageLogContext &, const QString &msg) {\n    QMutexLocker lock(&logMutex); // handler 可从多线程并发进入\n    writeRotatingLog(type, msg.toUtf8()); // 自有写入函数\n    if (type == QtFatalMsg) std::abort();\n}\nqInstallMessageHandler(messageHandler);\n// handler 内不能再调 qDebug/qWarning，否则递归；不要同步上传网络", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("031  如何实现 Qt 应用程序的权限管理？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Qt 只提供界面和系统 API，不会替业务定义权限模型；由可信后端或本地认证层验证身份和角色，再对每项敏感操作执行授权检查。隐藏按钮或禁用菜单仅改善体验，不能替代业务校验；通过集中权限服务管理策略，并记录拒绝和审计事件，避免把权限仅存于可篡改配置。服务器端权限检查应覆盖直接 API 调用，不能只依靠客户端界面限制。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("032  如何实现 Qt 应用程序的皮肤切换？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Widgets 可准备多套 QSS，在应用启动或用户切换时读取样式表并调用 qApp->setStyleSheet()；集中定义颜色和控件规则，减少组件覆盖。QML 可用统一 Theme 对象暴露调色板、间距和字体，让绑定自动更新；需重建或刷新缓存颜色，并检查原生平台样式、状态和可访问性。", size: 9.5pt)
  #raw("QFile qssFile(stylePath);\nif (!qssFile.open(QIODevice::ReadOnly)) return report(qssFile.errorString());\nqApp->setStyleSheet(QString::fromUtf8(qssFile.readAll())); // Widgets 换肤\n// QML：Theme 属性可绑定并驱动组件重绘\\ntheme.accent = \"#2878c8\"; theme.spacing = 12;\n// 组件按 theme 属性刷新自绘缓存；选择器尽量限制作用范围\n// 验证焦点、禁用态、平台原生外观和可访问性", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("033  如何实现 Qt 应用程序的自动更新功能？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  客户端用 QNetworkAccessManager 检查版本并下载更新包，先校验数字签名/哈希和目标平台，再由独立 updater 在主程序退出后替换文件。更新目录应避免半写入，保留回滚版本并处理中断、权限和磁盘空间；TLS 传输本身不能替代包签名，更新清单也要防降级攻击。把更新状态机设计为可恢复步骤，可在重启后判断下载、校验或替换是否完成。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("034  如何实现 Qt 应用程序的配置管理？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  用 QSettings 统一封装配置读写，设置组织名、应用名和默认值，通过 beginGroup() 分模块管理；退出前必要时 sync() 并检查 status()。适合窗口位置、偏好和非敏感参数，凭据应交给系统密钥链或安全凭据存储；为配置结构加版本迁移，避免升级后旧值被错误解释。同一应用的多个进程并发改写配置时，需关注 sync() 和冲突策略。", size: 9.5pt)
  #raw("QSettings settings;\nsettings.beginGroup(QStringLiteral(\"config\"));\nconst int version = settings.value(\"version\", 0).toInt();\nif (version < 2) migrateV1ToV2(settings); // 配置结构版本迁移\nsettings.setValue(\"version\", 2);\nsettings.endGroup(); settings.sync();\nif (settings.status() != QSettings::NoError) reportSettingsError();\n// 凭据放系统密钥链，不写普通 INI/注册表键", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("035  如何实现一个自定义的标题栏？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  用 Qt::FramelessWindowHint 移除系统装饰，再通过布局创建标题文本和最小化/最大化/关闭按钮；鼠标拖动可记录按下偏移并移动窗口，也可调用平台支持的系统移动接口保留贴边行为。还要实现双击最大化、边缘缩放、屏幕工作区、高 DPI 与键盘可访问性，交互差异需在目标平台验证。", size: 9.5pt)
  #raw("setWindowFlags(Qt::Window | Qt::FramelessWindowHint);\nauto *bar = new QWidget(this); auto *layout = new QHBoxLayout(bar);\nlayout->addWidget(titleLabel); layout->addWidget(closeButton);\nconnect(closeButton, &QPushButton::clicked, this, &QWidget::close);\nvoid TitleBar::mousePressEvent(QMouseEvent *e) {\n    dragOffset_ = e->globalPosition().toPoint() - window()->pos();\n}\nvoid TitleBar::mouseMoveEvent(QMouseEvent *e) {\n    if (e->buttons() & Qt::LeftButton)\n        window()->move(e->globalPosition().toPoint() - dragOffset_);\n}\n// 还需双击最大化、边缘缩放、高 DPI 与键盘操作", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("036  如何实现串口通信工具？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  链接 Qt SerialPort，先用 QSerialPortInfo::availablePorts() 枚举设备，再配置端口名、波特率、数据位、校验和停止位并 open(QIODevice::ReadWrite)。readyRead() 中读取并追加缓冲，按设备协议解析完整帧；检查错误和热拔插，并在 GUI 中避免 waitForReadyRead() 长时间阻塞。", size: 9.5pt)
  #raw("QSerialPort port(this); port.setPortName(portName);\nport.setBaudRate(QSerialPort::Baud115200);\nport.setDataBits(QSerialPort::Data8); port.setParity(QSerialPort::NoParity);\nport.setStopBits(QSerialPort::OneStop);\nif (!port.open(QIODevice::ReadWrite)) return report(port.errorString());\nconnect(&port, &QSerialPort::readyRead, this, [this] { buffer_ += port.readAll(); parseFrames(buffer_); });\n// 检查错误/拔出；GUI 线程不 waitForReadyRead() 阻塞", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("037  如何实现图片查看器？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QFileDialog 选图后用 QImageReader 检查格式、尺寸并解码，再以 QPixmap 显示在 QLabel 或由自绘控件按窗口缩放绘制；支持滚轮缩放、拖动和旋转时维护变换矩阵。超大图片可请求按目标大小解码，别在主线程反复全尺寸转换；保存时检查格式和写入错误。解码前设定像素尺寸上限，也可避免恶意图片触发内存耗尽。", size: 9.5pt)
  #raw("QImageReader reader(path);\nreader.setAutoTransform(true); // 应用 EXIF 方向\nreader.setScaledSize(targetPixels); // 避免解完整超大图\nQImage image = reader.read();\nif (image.isNull()) return report(reader.errorString());\npreview->setPixmap(QPixmap::fromImage(image)); // 在 GUI 线程显示\n// 保存用 QImageWriter 并检查错误；外部输入限制像素数\n// 滚轮缩放由变换矩阵控制，别反复全尺寸重采样", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("038  如何实现截图功能？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  桌面截图可取 QGuiApplication::screens() 中目标屏幕并用 QScreen::grabWindow(0) 获取 QPixmap，再预览或通过 save() 保存；多屏区域坐标和 devicePixelRatio 需正确换算。截取其他应用窗口受系统权限和平台限制，Wayland 等环境可能不允许任意全屏抓取，应提供授权或系统门户路径。", size: 9.5pt)
  #raw("QScreen *screen = QGuiApplication::primaryScreen();\nif (!screen) return report(QStringLiteral(\"no screen\"));\nQPixmap shot = screen->grabWindow(0); // 平台权限可能限制\nif (shot.isNull()) return report(QStringLiteral(\"capture unavailable\"));\nif (!shot.save(outputPath)) return report(QStringLiteral(\"save failed\"));\n// 多屏先按窗口所在 QScreen 选择并换算 DPR/逻辑坐标\n// Wayland 等环境应走平台授权门户", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("039  如何实现数据可视化图表？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  图表可选 Qt Graphs、旧有 Qt Charts、第三方库或自绘；折线适合趋势、柱状适合分类比较，数据和坐标轴最好由模型层管理。注意版本变化：Qt Charts 自 Qt 6.10 起已弃用，新项目应评估 Qt Graphs；动态图表要限制刷新率和点数，并测试目标后端性能。图表库通常面向数据可视化而非高频海量散点，超大数据应抽稀或分层聚合。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("040  如何实现窗口的无边框和拖动？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  通过 setWindowFlags(Qt::FramelessWindowHint) 创建无系统边框窗口，自定义标题区域处理鼠标拖动：记录按下时全局坐标与窗口位置，仅左键移动时更新位置。手动方案还要实现边缘缩放、双击最大化和多屏边界；优先使用系统窗口移动/调整大小接口时需按目标 Qt 和平台确认支持。", size: 9.5pt)
  #raw("setWindowFlags(Qt::Window | Qt::FramelessWindowHint);\nvoid Window::mousePressEvent(QMouseEvent *e) {\n    if (e->button() == Qt::LeftButton) dragOffset_ = e->globalPosition().toPoint() - pos();\n}\nvoid Window::mouseMoveEvent(QMouseEvent *e) {\n    if (e->buttons() & Qt::LeftButton) move(e->globalPosition().toPoint() - dragOffset_);\n}\n// 优先用平台原生 startSystemMove；手动窗口还需边缘缩放\n// 多屏边界、最大化恢复和无障碍键盘操作都要处理", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("041  如何实现系统托盘功能？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  创建 QSystemTrayIcon，设置有效图标和提示文本，调用 setContextMenu() 绑定 QMenu，并连接 activated() 响应单击、双击或菜单触发。先检查 isSystemTrayAvailable()，关闭主窗时可隐藏而不退出，并提供从托盘恢复和真正退出的路径；不同桌面环境对托盘激活行为可能不同。", size: 9.5pt)
  #raw("QSystemTrayIcon tray(QIcon(\":/icons/app.png\"), this);\nif (!QSystemTrayIcon::isSystemTrayAvailable()) reportNoTray();\nauto *menu = new QMenu(this); menu->addAction(tr(\"Show\"), this, &Window::showNormal);\nmenu->addAction(tr(\"Quit\"), qApp, &QCoreApplication::quit);\ntray.setContextMenu(menu);\nconnect(&tray, &QSystemTrayIcon::activated, this, [this](auto reason) {\n    if (reason == QSystemTrayIcon::Trigger) showNormal();\n});\ntray.show(); // 关闭窗口可 hide 而不是退出，并保留真正退出入口", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("042  如何实现网络调试助手？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  界面可组合 QTcpSocket 客户端、QTcpServer 服务端和 QUdpSocket 数据报模式，用状态区显示连接、错误、发送和接收日志。以 QByteArray 缓冲收发并明确十六进制/ASCII 编码、帧边界和最大长度；自动发送用 QTimer，限制高频速率和日志容量，避免大量文本刷新拖慢界面。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("043  如何实现聊天软件的界面？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  消息列表用 QAbstractListModel 保存发送者、时间、正文、状态和头像等字段，QListView 配合自定义 Delegate 绘制左右气泡；输入栏、附件和发送动作由独立控件负责。分页历史和新消息分批更新模型，长消息按宽度换行；网络收发放后台异步层，不能在 delegate 绘制时读取数据库或阻塞请求。", size: 9.5pt)
  #raw("class MessageModel : public QAbstractListModel { /* roles: body/time/status */ };\nMessageModel model; QListView list; list.setModel(&model);\nlist.setItemDelegate(new BubbleDelegate(&list)); // delegate 绘制气泡而非每行 QWidget\nconnect(sendButton, &QPushButton::clicked, this, [this] {\n    emit sendRequested(input->text()); input->clear();\n});\nconnect(networkWorker, &Worker::messageReceived, &model, &MessageModel::append,\n        Qt::QueuedConnection);\n// 分页载入历史；绘制时不查数据库/不做网络请求", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("044  如何实现视频播放器？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Qt 6 可用 QMediaPlayer::setSource() 载入媒体，通过 setVideoOutput(QVideoWidget*) 显示画面，再提供 play()/pause()、positionChanged 和 durationChanged 进度控制。音量由 QAudioOutput 管理；格式与编解码能力依平台后端，需检查错误和缓冲状态，并对 Qt 5 旧接口及 QMediaPlaylist 移除情况做版本迁移。", size: 9.5pt)
  #raw("auto *player = new QMediaPlayer(this);\nauto *audio = new QAudioOutput(this); player->setAudioOutput(audio);\nauto *video = new QVideoWidget(this); player->setVideoOutput(video);\nconnect(player, &QMediaPlayer::errorOccurred, this, &Window::showMediaError);\nconnect(player, &QMediaPlayer::positionChanged, slider, &QSlider::setValue);\nplayer->setSource(QUrl::fromLocalFile(filePath)); player->play();\n// 检查后端格式/缓冲状态；音量由 QAudioOutput 管理", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("045  如何对 Qt 应用程序进行单元测试？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  用 Qt Test 测纯业务对象、模型数据和信号行为，QSignalSpy 可验证信号发射；把网络、时钟和文件系统依赖抽象后用 fake/mock 隔离，减少不稳定外部条件。UI 可通过 QTest::mouseClick/keyClicks 模拟交互，但截图和时序测试需稳定环境；在 CI 为关键回归自动构建并运行测试。", size: 9.5pt)
  #raw("QSignalSpy spy(&model, &Model::dataChanged);\nmodel.setData(model.index(0, 0), QStringLiteral(\"new\"));\nQCOMPARE(spy.size(), 1); // 验证信号和状态\nQTest::mouseClick(widget.submitButton(), Qt::LeftButton);\nQCOMPARE(widget.statusText(), QStringLiteral(\"Done\"));\n// 把网络/时钟/文件系统依赖注入 fake，测试可重复\n// CI 链接 Qt6::Test 并运行 QTest suite", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("046  如何自定义消息处理函数？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  通过 qInstallMessageHandler(handler) 替换默认日志出口，handler 接收 QtMsgType、上下文和消息，可统一写控制台或文件并附时间、线程标识。安装后由当前进程日志调用它，函数应线程安全且避免递归调用 qDebug；保存前做好轮转、编码和脱敏，退出时安全刷新文件。", size: 9.5pt)
  #raw("static QMutex outputMutex;\nvoid handler(QtMsgType type, const QMessageLogContext &ctx, const QString &msg) {\n    QMutexLocker lock(&outputMutex); // 可能由多个线程调用\n    appendWithTimestamp(type, ctx.category, msg.toUtf8());\n    // 不在 handler 中再次调用 qDebug，避免递归\n}\nauto oldHandler = qInstallMessageHandler(handler);\n// 退出时刷新并恢复 oldHandler；写入做轮转和隐私脱敏", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("047  如何解决 Qt 中文乱码问题？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先确认源文件为 UTF-8、编译器和终端编码正确；QString 保存 Unicode 文本，读网络 QByteArray 时按协议用 fromUtf8 等明确解码，写文件也指定编码。Qt 6 默认 UTF-8，Qt 5 的本地 8 位编码 API 不应直接照搬；检查同一文本在日志、控件和导出文件各环节的字节转换。", size: 9.5pt)
  #raw("QByteArray incoming = socket->readAll(); // 网络层先得到字节\nQString text = QString::fromUtf8(incoming); // 按协议编码解码\nQFile file(path); if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) return;\nQTextStream out(&file); out.setEncoding(QStringConverter::Utf8);\nout << text; // 文件编码也明确为 UTF-8\nqInfo().noquote() << text; // 日志终端另检查编码设置\n// QString 是 Unicode 文本；不要把本地 8 位编码当 UTF-8", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("048  如何解决 Qt 多线程中的数据竞争问题？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先确定数据竞争发生在哪些共享字段，再让单一线程拥有对象或用 QMutex/QReadWriteLock 把所有访问纳入临界区；尽量以不可变副本和排队消息传递结果。QueuedConnection 只把槽排到接收者线程，并不会保护外部共享变量；避免多个线程直接调用有事件的 QObject，也不要跨线程操作 QWidget。", size: 9.5pt)
  #raw("connect(worker, &Worker::resultReady, controller, &Controller::apply,\n        Qt::QueuedConnection); // 消息传递优先\nQMutexLocker lock(&stateMutex); // 所有访问共享状态的路径都持同锁\nsharedState = nextState;\n// 队列连接只安排槽执行，不保护另一个共享变量\n// GUI 控件只在 GUI 线程访问；可改传不可变副本\n// ThreadSanitizer/sanitizer 用于复现并定位竞争", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("049  如何解决 Qt 界面卡顿问题？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  用 profiler 判断卡顿来自主线程计算、同步磁盘/网络、布局还是过量重绘，再把独立耗时任务移到 worker 并异步汇报进度。大数据展示改用 Model/View、批量提交模型通知并合并刷新；setUpdatesEnabled(false) 只适合短暂批量改控件，需恢复更新且不能解决阻塞原因。", size: 9.5pt)
  #raw("auto *watcher = new QFutureWatcher<Result>(this);\nconnect(watcher, &QFutureWatcher<Result>::finished, this, [this, watcher] {\n    model->apply(watcher->result()); watcher->deleteLater();\n});\nwatcher->setFuture(QtConcurrent::run([input] { return crunch(input); }));\n// 数据批量更新用 begin/end 模型通知；合并 update 区域\n// setUpdatesEnabled(false) 只包围短批量界面修改并恢复\n// profile 找到主线程热点后再优化", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("050  如何解决 Qt 程序假死的问题？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  假死通常是 GUI 线程长时间执行计算、同步 I/O、等待锁或嵌套等待，导致事件循环不能处理输入和重绘；用采样器和线程栈确认阻塞点。改成 QThread/QtConcurrent 或异步网络流程，通过信号回传结果并支持取消；processEvents() 会引入重入，只适合谨慎的短期过渡。", size: 9.5pt)
  #raw("QThreadPool::globalInstance()->start([this] {\n    const Result result = blockingIoOrCompute(); // 移出 GUI 事件回调\n    QMetaObject::invokeMethod(this, [this, result] {\n        apply(result); // 结果回 GUI 线程\n    }, Qt::QueuedConnection);\n});\n// 任务要有取消/超时；分析线程栈定位锁、同步 I/O 或等待环\n// processEvents 会重入，不应用来掩盖长期阻塞", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("051  如何解决 Qt 程序在高分屏下显示模糊的问题？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Qt 6 默认启用高 DPI 缩放，布局尺寸通常按逻辑像素处理，图片资源需提供合适倍率或 SVG；读取原始像素时用 devicePixelRatio 区分物理尺寸。避免硬编码固定像素和手工重复缩放；Qt 5 的高 DPI 属性设置有版本差异，迁移时按目标版本核对而不要照抄旧开关。多屏窗口移动后应读取当前 QScreen，而不是假设主屏幕缩放比例恒定。", size: 9.5pt)
  #raw("QScreen *screen = window->screen(); // 多屏移动后重新查询\nconst qreal dpr = screen ? screen->devicePixelRatio() : 1.0;\nconst QSize physical = (logicalSize * dpr).toSize();\nQImage image(physical, QImage::Format_ARGB32_Premultiplied);\nimage.setDevicePixelRatio(dpr); // 布局仍使用逻辑像素\n// 图片资源提供合适倍率或 SVG；避免手工重复缩放\n// Qt 5 高 DPI 开关随版本变化，按目标版本确认", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("052  如何设计一个 Qt 项目的架构？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  按职责划分界面层、业务用例层和数据/设备适配层，让 Widget/QML 负责呈现，业务逻辑尽量不依赖具体控件；Model/View 管理大批数据，信号槽连接边界事件。公共日志、配置和网络模块通过明确接口复用；用依赖注入隔离外部服务，模块规模应随实际复杂度增长而非先建空壳。模块之间通过纯 C++ 接口或信号槽依赖，降低替换界面框架的成本。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("053  如何避免不必要的信号槽连接？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  重复 connect 默认会建立多条连接，同一信号每次发射就可能多次调用槽；固定初始化只连接一次，动态连接可用 Qt::UniqueConnection 防止重复的成员槽连接。UniqueConnection 对 lambda/functor 形式不适用，需保存 QMetaObject::Connection 并按生命周期断开；大量条目应通过 model/view 批量表达状态。", size: 9.5pt)
  #raw("QMetaObject::Connection connection;\nvoid Controller::startObserving() {\n    if (connection) return; // 固定初始化只连一次\n    connection = connect(source, &Source::changed, this, &Controller::refresh);\n}\nvoid Controller::stopObserving() { QObject::disconnect(connection); connection = {}; }\n// UniqueConnection 适用于成员槽，不支持 lambda/functor 去重\n// 动态生命周期可保存句柄并显式断开", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("054  如何配置 Qt 的静态编译？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先用官方配置流程构建一套 static Qt Kit（如源码配置 -static），应用再链接该 Kit 的静态模块；CMake/qmake 配置要匹配实际安装，平台插件和图片格式等静态插件可能需显式导入。静态部署会增加二进制体积、依赖和升级成本，检查每个第三方库及 Qt 许可证义务，不能只加 CONFIG += static 就认为 Qt 已静态化。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("055  智能指针在 Qt 中如何使用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  QScopedPointer 管理独占作用域资源，QSharedPointer 用引用计数共享普通对象，QWeakPointer 可打破共享指针环；C++ 的 unique_ptr/shared_ptr 也可用于非 QObject 资源。QObject 通常由父子树拥有，QPointer 只观察对象是否仍存活；不要让 parent 删除和 shared_ptr 同时拥有同一个 QObject，以免双重释放。", size: 9.5pt)
  #raw("auto owned = std::make_unique<PlainResource>(); // 普通 C++ 资源独占\nQPointer<QObject> observer = object; // 只观察 QObject，不拥有\nif (observer) observer->deleteLater(); // 由对象线程事件循环处理\nQSharedPointer<Cache> shared = QSharedPointer<Cache>::create(); // 共享非 QObject 数据\nQWeakPointer<Cache> weak = shared.toWeakRef(); // 可观察而不形成强引用环\n// QObject 用 parent 或单一智能指针所有权，不能两者都拥有", lang: "cpp", block: true)
]

#heading(level: 1, outlined: true)[#text("第15章 OpenCV 与计算机视觉", size: 15pt, weight: "bold", fill: rgb("#000000"))]
#heading(level: 2, outlined: true)[#text("15.1 图像基础与常用处理", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  Canny 边缘检测", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先将图像转成单通道灰度图，必要时先用高斯滤波抑制噪声，再调用 Canny(gray, edges, 50, 150)。算法计算梯度、做非极大值抑制，并用双阈值滞后连接边缘：强边缘保留，介于两阈值的弱边缘仅在连到强边缘时保留；阈值应结合图像对比度调试。", size: 9.5pt)
  #raw("cv::Mat gray = cv::imread(path, cv::IMREAD_GRAYSCALE);\nif (gray.empty()) return reportReadFailure();\ncv::Mat smooth, edges;\ncv::GaussianBlur(gray, smooth, cv::Size(5, 5), 0); // 先抑制噪声\ncv::Canny(smooth, edges, lowThreshold, highThreshold);\nshow(edges);\n// 高阈值找强边缘，低阈值参与滞后连接；按图像对比度调参", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  Haar 级联分类器进行人脸检测", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先用 CascadeClassifier::load 加载与 OpenCV 版本匹配的 XML 模型，将输入转灰度，必要时 equalizeHist，再以 detectMultiScale 检测矩形。scaleFactor 控制逐级缩小图像的比例，minNeighbors 用于合并相邻候选框；返回框可用 rectangle 绘制。Haar 速度快、无需 GPU，但侧脸、遮挡和光照变化会显著降低召回率。", size: 9.5pt)
  #raw("cv::CascadeClassifier detector;\nif (!detector.load(cascadeXml) || detector.empty()) return reportModelError();\ncv::Mat gray, equalized;\ncv::cvtColor(frame, gray, cv::COLOR_BGR2GRAY);\ncv::equalizeHist(gray, equalized); // 光照允许时增强局部对比\nstd::vector<cv::Rect> faces;\ndetector.detectMultiScale(equalized, faces, 1.1, 3, 0, cv::Size(30, 30));\nfor (const auto &face : faces) cv::rectangle(frame, face, cv::Scalar(0, 255, 0), 2);\n// scaleFactor/minNeighbors 改变速度与候选框过滤强度", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  Mat 和 IplImage 的区别", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  IplImage 是旧 C API 的结构体，常需 cvLoadImage/cvReleaseImage 手动管理，字段和步长也由调用者处理；cv::Mat 是 C++ 矩阵类，析构时通过引用计数释放存储，支持 ROI 和丰富运算。Mat 的普通复制通常共享像素数据，独立副本需 clone；新代码优先用 Mat，旧接口可用 cvarrToMat 过渡。", size: 9.5pt)
  #raw("IplImage *legacy = cvLoadImage(path, CV_LOAD_IMAGE_COLOR);\nif (!legacy) return reportReadFailure();\ncv::Mat borrowed = cv::cvarrToMat(legacy); // 仍依赖 legacy 的数据生命周期\ncv::Mat owned = borrowed.clone(); // 复制像素后才可独立使用\ncvReleaseImage(&legacy); // 旧 C API 必须显式释放\nprocess(owned); // cv::Mat 析构按引用计数回收自己的缓冲区\n// 新代码优先用 Mat；ROI/普通复制仍可能共享像素", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  OpenCV 如何读写图像并进行 BGR 灰度转换？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  用 imread(path, IMREAD_COLOR) 读入并检查 empty()；默认彩色顺序是 BGR，可用 cvtColor(img, gray, COLOR_BGR2GRAY) 转灰度，只有明确需要 RGB 时才转 RGB。imshow 后用 waitKey 处理窗口事件，按 q 退出；imwrite 会按扩展名选择编码器，应检查返回值，且 GUI 窗口功能在无桌面环境可能不可用。", size: 9.5pt)
  #raw("cv::Mat bgr = cv::imread(path, cv::IMREAD_COLOR); // 默认 BGR\nif (bgr.empty()) return reportReadFailure();\ncv::Mat gray; cv::cvtColor(bgr, gray, cv::COLOR_BGR2GRAY);\ncv::imshow(\"gray\", gray);\nconst int key = cv::waitKey(1); // 驱动 HighGUI 窗口事件\nif (key == 'q') closeWindow();\nif (!cv::imwrite(outputPath, gray)) reportWriteFailure();\n// 无桌面环境不要依赖 imshow；编码器由扩展名选择", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  OpenCV 用什么语言编写？支持哪些平台？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  OpenCV 核心主要以 C++ 实现，C++ 是最完整的接口，常见官方语言绑定有 Python、Java，另有受构建配置影响的其他绑定。可在 Windows、Linux、macOS、Android、iOS 等平台编译或使用预构建包；具体模块、摄像头后端、GPU 和编解码能力取决于平台依赖及构建选项。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  SIFT、SURF 和 ORB 的区别", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  SIFT 在尺度空间检测关键点并生成通常为 128 维浮点描述子，匹配常用 L2；SURF 用积分图等方法加速尺度不变特征，但常由 opencv_contrib 的 xfeatures2d 提供。ORB 以 FAST 检点、方向化 BRIEF 描述，输出二进制串，宜用 Hamming 距离，通常速度和内存更省；实际检测效果还受尺度、模糊和版本构建影响。", size: 9.5pt)
  #raw("auto sift = cv::SIFT::create(); // 通常产生浮点描述子\nauto orb = cv::ORB::create(500); // 二进制描述子\nstd::vector<cv::KeyPoint> ks, ko; cv::Mat ds, dorb;\nsift->detectAndCompute(gray, cv::noArray(), ks, ds);\norb->detectAndCompute(gray, cv::noArray(), ko, dorb);\ncv::BFMatcher l2(cv::NORM_L2), hamming(cv::NORM_HAMMING);\nl2.match(ds, siftMatches); hamming.match(dorb, orbMatches);\n// SURF 需对应 contrib/build 配置；算法效果还受尺度和模糊影响", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("007  cv::findContours() 的作用 & 绘制轮廓", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  findContours 从 8 位二值图中追踪边界，输出轮廓点集和可选的父子层级；RETR_EXTERNAL 只取外轮廓，RETR_TREE 保留嵌套关系，CHAIN_APPROX_SIMPLE 会压缩直线段上的冗余点。之后可用 drawContours 绘制，也可算面积、周长或包围框。OpenCV 3.2 起通常不修改输入，但跨版本或需保留掩码时传入副本最稳妥。", size: 9.5pt)
  #raw("cv::Mat work = binary.clone(); // 保留原掩码，兼顾版本差异\nstd::vector<std::vector<cv::Point>> contours;\nstd::vector<cv::Vec4i> hierarchy;\ncv::findContours(work, contours, hierarchy, cv::RETR_TREE, cv::CHAIN_APPROX_SIMPLE);\nfor (std::size_t i = 0; i < contours.size(); ++i) {\n    const double area = cv::contourArea(contours[i]);\n    if (area > minArea) cv::drawContours(canvas, contours, static_cast<int>(i), cv::Scalar(0, 255, 0), 2);\n}\n// RETR_TREE 保留层级；外轮廓场景可用 RETR_EXTERNAL", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("008  cv::split() 与 cv::merge()", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  split 把多通道 Mat 拆成若干单通道 Mat，例如 BGR 拆为 B、G、R；merge 则要求各输入尺寸和深度兼容，再按给定顺序组合成多通道图像。它们适合分别处理色彩平面，但会产生额外矩阵和带宽开销；若只需访问像素通道，考虑 Vec 类型或直接按行遍历，并牢记 OpenCV 彩色图通常为 BGR。", size: 9.5pt)
  #raw("std::vector<cv::Mat> channels;\ncv::split(bgr, channels); // B、G、R 单通道矩阵\nchannels[2] = cv::Mat::zeros(bgr.size(), CV_8UC1); // 仅保留 B/G\ncv::Mat merged;\ncv::merge(channels, merged); // 尺寸、深度必须兼容\n// 额外 split/merge 会占带宽和内存\ncv::Vec3b pixel = bgr.at<cv::Vec3b>(y, x); // 单点访问可直接读通道\n// OpenCV 彩色顺序通常是 BGR", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("15.2 特征、变换与视觉算法", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("009  什么是 OpenCV？它的主要特性有哪些？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  OpenCV 是开源的计算机视觉与图像处理库，核心模块提供 Mat、几何变换、滤波、阈值和形态学等基础能力；常用扩展覆盖特征检测、标定、视频 I/O、目标检测及机器学习。C++/Python 接口可组合传统算法与 DNN 推理。CPU 优化较普遍，CUDA 等加速需相应构建和硬件支持，并非每个函数都能自动使用 GPU。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("010  光流 (Optical Flow) & Farneback 方法", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  光流估计两帧间像素位移；Farneback 在局部邻域以多项式近似灰度变化，再从系数变化估计稠密运动。OpenCV 用 calcOpticalFlowFarneback(prev, next, flow, ...) 输出 CV_32FC2 位移场，flow(y,x) 的两个分量是水平、垂直位移。需输入尺寸一致，快速大运动、弱纹理、遮挡和亮度突变会破坏局部匹配假设。", size: 9.5pt)
  #raw("cv::Mat flow;\ncv::calcOpticalFlowFarneback(previousGray, currentGray, flow,\n                             0.5, 3, 15, 3, 5, 1.2, 0);\n// flow 为 CV_32FC2；两个分量分别是水平/垂直位移\nconst cv::Point2f motion = flow.at<cv::Point2f>(y, x);\ndrawArrow(frame, cv::Point(x, y), cv::Point2f(x, y) + motion);\n// 两帧尺寸应一致；弱纹理、遮挡和快速运动会破坏局部假设\npreviousGray = currentGray.clone(); // 为下一次保留独立帧", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("011  单应性矩阵 (Homography) & 计算", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  单应矩阵 H 是 3×3 投影变换，齐次坐标满足 x′ ∼ Hx，可描述同一平面在两视角中的映射，也可近似纯旋转相机的成像变化。至少需要四组不退化的对应点；实际常用 findHomography(..., RANSAC) 在多组匹配中剔除外点，再由 warpPerspective 映射。场景存在明显深度视差时，一个 H 无法同时对齐所有物体。", size: 9.5pt)
  #raw("cv::Mat inliers;\ncv::Mat H = cv::findHomography(srcPoints, dstPoints, cv::RANSAC, 3.0, inliers);\nif (H.empty()) return reportDegenerateMatches();\ncv::Mat warped;\ncv::warpPerspective(source, warped, H, outputSize, cv::INTER_LINEAR,\n                    cv::BORDER_CONSTANT);\n// 至少四对不退化对应点；mask 标出 RANSAC 内点\n// 单一 H 不适用于明显深度视差场景", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("012  图像拼接 (Image Stitching)", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先检测并描述两幅图的特征，以匹配距离和比率检验筛选对应点，用 RANSAC 估计单应矩阵，再将图像变换到统一画布并融合重叠区域。需先计算变换后边界并平移坐标，避免负坐标被裁掉；曝光补偿和羽化/多频带融合可减轻接缝。单一单应性适合平面场景或相机绕光心旋转，近景视差会造成重影。", size: 9.5pt)
  #raw("auto orb = cv::ORB::create(1500);\norb->detectAndCompute(leftGray, cv::noArray(), leftKeys, leftDesc);\norb->detectAndCompute(rightGray, cv::noArray(), rightKeys, rightDesc);\ncv::BFMatcher(cv::NORM_HAMMING).knnMatch(rightDesc, leftDesc, pairs, 2);\nfilterRatioMatches(pairs, good); // 比率检验减少歧义匹配\ncv::Mat H = cv::findHomography(rightPoints, leftPoints, cv::RANSAC, 3.0, inliers);\nif (H.empty()) return reportNoAlignment();\ncv::warpPerspective(rightImage, warped, H, canvasSize); // 先计算平移画布边界\nblendOverlap(leftImage, warped); // 羽化/曝光补偿缓解接缝\n// 平面/纯旋转较适用；近景视差会重影", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("013  图像旋转", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  用 getRotationMatrix2D(center, angle, scale) 生成 2×3 仿射矩阵，再以 warpAffine 采样输出；角度按 OpenCV 定义传入，正负方向应按坐标系确认。若沿用原宽高，旋转后边角可能被裁剪；要完整保留内容，应根据 |cosθ|、|sinθ| 计算新画布宽高，并相应平移矩阵中的中心坐标。", size: 9.5pt)
  #raw("const cv::Point2f center(image.cols / 2.0f, image.rows / 2.0f);\ncv::Mat M = cv::getRotationMatrix2D(center, angleDegrees, 1.0);\nconst double radians = angleDegrees * CV_PI / 180.0;\nconst int outW = static_cast<int>(std::ceil(std::abs(image.cols * std::cos(radians)) +\n                                            std::abs(image.rows * std::sin(radians))));\nconst int outH = static_cast<int>(std::ceil(std::abs(image.rows * std::cos(radians)) +\n                                            std::abs(image.cols * std::sin(radians))));\nM.at<double>(0, 2) += outW / 2.0 - center.x; M.at<double>(1, 2) += outH / 2.0 - center.y;\ncv::warpAffine(image, rotated, M, cv::Size(outW, outH)); // 平移后保留完整画布", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("014  图像金字塔 (Image Pyramid)", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  高斯金字塔每层先低通再下采样，可用 pyrDown 构造，常用于多尺度检测和配准；拉普拉斯金字塔记录相邻高斯层之间的高频残差，形式上是 G_i 减去上采样的 G_{i+1}。它可用于多尺度融合，重建时逐层上采样并加回残差；尺寸取整和边界处理须保持一致。", size: 9.5pt)
  #raw("std::vector<cv::Mat> gaussian{image};\nfor (int level = 0; level < levels; ++level) {\n    cv::Mat next; cv::pyrDown(gaussian.back(), next); gaussian.push_back(next);\n}\nstd::vector<cv::Mat> laplacian;\nfor (std::size_t i = 0; i + 1 < gaussian.size(); ++i) {\n    cv::Mat up, detail; cv::pyrUp(gaussian[i + 1], up, gaussian[i].size());\n    cv::subtract(gaussian[i], up, detail); laplacian.push_back(detail);\n}\n// 重建需用相同尺寸取整与边界规则逐层上采样后加回", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("015  图像阈值化 / 二值化", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  threshold(gray, binary, 127, 255, THRESH_BINARY) 对每个像素独立比较：大于阈值写入 maxval 255，其余写 0；等于阈值也归入 0。输入通常是灰度图，固定阈值适用于光照均匀的场景；照明不均可用 adaptiveThreshold，未知双峰分布可先试 Otsu 自动选阈值。", size: 9.5pt)
  #raw("cv::Mat binary;\nconst double used = cv::threshold(gray, binary, 127, 255, cv::THRESH_BINARY);\n// 大于 127 的像素变 255；等于阈值及更小值变 0\ncv::threshold(gray, otsu, 0, 255, cv::THRESH_BINARY | cv::THRESH_OTSU);\n// Otsu 根据直方图选阈值，仍要求单通道输入\n// 光照不均可改 adaptiveThreshold；标签图不要线性插值", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("016  如何使用 ORB 进行特征检测", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  创建 ORB 后调用 detectAndCompute(gray, mask, keypoints, descriptors)，它同时检测关键点并计算方向化 BRIEF 二进制描述子；可用 BFMatcher(NORM_HAMMING) 做匹配，kNN 后再用距离比筛掉歧义点。max features、scaleFactor 和 nlevels 控制点数及尺度层级。ORB 很快且无需浮点描述子，但大尺度变化和严重模糊下不一定稳定。", size: 9.5pt)
  #raw("auto orb = cv::ORB::create(1000, 1.2f, 8);\nstd::vector<cv::KeyPoint> keypoints; cv::Mat descriptors;\norb->detectAndCompute(gray, mask, keypoints, descriptors);\ncv::BFMatcher matcher(cv::NORM_HAMMING);\nmatcher.knnMatch(descriptors, referenceDescriptors, pairs, 2);\nfor (const auto &pair : pairs)\n    if (pair.size() == 2 && pair[0].distance < 0.75f * pair[1].distance) good.push_back(pair[0]);\n// ORB 描述子是二进制串，匹配用 Hamming 距离", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("017  如何调整图像大小", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  resize(src, dst, Size(w,h)) 指定像素尺寸，也可用 fx、fy 指定缩放比例；缩小时 INTER_AREA 通常能减少混叠，放大常用 INTER_LINEAR 或较锐的 INTER_CUBIC，类别标签图应使用 INTER_NEAREST。保持宽高比时按同一比例计算两边，并另行补边或裁剪；检查输入非空，视频还要正确处理每帧色彩和 stride。", size: 9.5pt)
  #raw("if (source.empty()) return reportReadFailure();\ncv::Mat smaller;\ncv::resize(source, smaller, cv::Size(), 0.5, 0.5, cv::INTER_AREA); // 缩小\ncv::Mat larger;\ncv::resize(source, larger, cv::Size(), 2.0, 2.0, cv::INTER_CUBIC); // 放大\n// 相同比例保持宽高比；标签/掩码使用 INTER_NEAREST\n// resize 输出是 Mat，逐行访问仍须尊重 step/stride", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("018  模板匹配 (Template Matching)", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  matchTemplate 在源图上逐位置滑动模板，产生尺寸约为 (W−w+1)×(H−h+1) 的响应图，再用 minMaxLoc 找极值：平方差类取最小，相关/归一化相关类通常取最大。需保证模板不大于搜索图并选合适方法；该方法不天然处理尺度旋转变化，对亮度变化也敏感，可先限制 ROI 或做图像金字塔搜索。", size: 9.5pt)
  #raw("if (templ.cols > image.cols || templ.rows > image.rows) return;\ncv::Mat response;\ncv::matchTemplate(image, templ, response, cv::TM_CCOEFF_NORMED);\ndouble minScore = 0.0, maxScore = 0.0; cv::Point minLoc, maxLoc;\ncv::minMaxLoc(response, &minScore, &maxScore, &minLoc, &maxLoc);\nconst cv::Point best = maxLoc; // 相关度方法取最大；平方差取最小\ncv::rectangle(image, best, best + templ.size(), cv::Scalar(0, 255, 0), 2);\n// 尺度/旋转不天然鲁棒；可先限制 ROI 或建金字塔", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("15.3 视频分析与相机标定", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("019  直方图均衡化", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  equalizeHist 对单通道 8 位灰度图重映射累计直方图，拉开集中在窄范围的亮度分布；它会同时改变噪声和局部对比度。彩色图不要独立均衡 B、G、R，否则易偏色，可转 YCrCb 或 Lab 只处理亮度通道；光照变化剧烈时 CLAHE 以局部块均衡并限制对比度，通常更自然。", size: 9.5pt)
  #raw("cv::Mat equalized;\ncv::equalizeHist(gray, equalized); // 仅单通道 8-bit 灰度\ncv::Mat ycrcb; cv::cvtColor(bgr, ycrcb, cv::COLOR_BGR2YCrCb);\nstd::vector<cv::Mat> planes; cv::split(ycrcb, planes);\ncv::equalizeHist(planes[0], planes[0]); // 仅均衡亮度 Y\ncv::merge(planes, ycrcb);\ncv::Mat result; cv::cvtColor(ycrcb, result, cv::COLOR_YCrCb2BGR);\n// 彩色直接均衡 B/G/R 容易偏色；强光差可用 CLAHE", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("020  视频中颜色跟踪", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  逐帧把 BGR 转 HSV，用 inRange 生成颜色掩码，再用开/闭运算去小噪声或填孔，按面积筛轮廓并以矩计算质心；相邻帧可用最近邻或卡尔曼滤波保持目标身份。HSV 对亮度有一定解耦，但色相受照明影响；红色跨 Hue 首尾边界时要分两段阈值后 OR 合并。", size: 9.5pt)
  #raw("cv::VideoCapture capture(device);\nif (!capture.isOpened()) return reportCameraFailure();\nwhile (capture.read(frame)) {\n    cv::cvtColor(frame, hsv, cv::COLOR_BGR2HSV);\n    cv::inRange(hsv, lowerHsv, upperHsv, mask);\n    cv::morphologyEx(mask, clean, cv::MORPH_OPEN, kernel); // 去小噪点\n    cv::findContours(clean, contours, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);\n    selectLargestAndUpdateCentroid(contours); // 面积筛选/跨帧关联\n}\n// 红色 Hue 跨首尾范围时分两次 inRange 后 OR 合并", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("021  透视变换 (Perspective Transform)", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  四对点按源点与目标点一一对应传给 getPerspectiveTransform，得到 3×3 矩阵后用 warpPerspective(src, dst, H, outputSize)。点的顺序必须一致、不能三点共线导致退化；四点适合直接求解，多于四对带噪声的点应使用 findHomography 和 RANSAC。输出画布、边界填充值和插值方式需按用途指定。", size: 9.5pt)
  #raw("const std::vector<cv::Point2f> sourceCorners{a, b, c, d};\nconst std::vector<cv::Point2f> targetCorners{p, q, r, s}; // 顺序一一对应\ncv::Mat H = cv::getPerspectiveTransform(sourceCorners, targetCorners);\nif (H.empty()) return reportDegenerateCorners();\ncv::warpPerspective(source, output, H, outputSize, cv::INTER_LINEAR,\n                    cv::BORDER_CONSTANT, cv::Scalar());\n // 点不可退化/共线；多于四对含噪点改 findHomography + RANSAC\n// 输出尺寸和边界填充值按目标画布设置", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("022  高斯模糊", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  GaussianBlur(src, dst, Size(5,5), 0) 用二维高斯核加权邻域，抑制高频噪声并为边缘检测等步骤做预平滑；核宽高通常取正奇数，sigmaX 为 0 时由核尺寸推导，sigmaY 默认沿用 sigmaX。核越大平滑越强，也越会模糊细节；边缘附近的填充由 borderType 决定。", size: 9.5pt)
  #raw("cv::Mat blurred;\ncv::GaussianBlur(source, blurred, cv::Size(5, 5), 0, 0, cv::BORDER_DEFAULT);\n// 奇数核宽高；sigmaX 为 0 时由核尺寸推导\n// sigmaY 为 0 时沿用 sigmaX\ncv::Canny(blurred, edges, low, high); // 平滑降低噪声误检\n// 核越大平滑越强，也会损失边缘细节；检查输入为空", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("023  cv::Mat 的拷贝构造和 clone() 有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Mat 的拷贝构造和赋值通常只复制矩阵头并增加引用计数，像素仍共享，因此修改元素会影响另一视图；ROI 也属于共享视图。clone() 分配连续的新存储并复制元素，适合异步保存、跨线程传递或需要独立改写的场景。仅重新赋值某个 Mat 头不会自动复制；多线程共享时仍需避免无保护的并发写。〔S14〕", size: 9.5pt)
  #raw("cv::Mat shared = image; // 浅拷贝矩阵头，像素共享\nshared.at<cv::Vec3b>(0, 0)[0] = 255; // 修改会影响 image\ncv::Mat independent = image.clone(); // 分配并复制像素\nindependent.at<cv::Vec3b>(0, 0)[0] = 0; // 原图不变\nenqueueForWorker(independent); // 异步/跨线程独立修改更安全\n// 只改 Mat 头的赋值不会深拷贝；并发写仍要同步", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("024  OpenCV 的 ROI 为什么可能不是连续内存？处理时要注意什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  ROI 是父 Mat 数据的矩形视图，通常只创建新矩阵头；每行仍按父图的 step 前进，末尾还有 ROI 右侧未包含的像素，所以不连续。用 ptr<T>(row) 或 step 逐行访问，只有 isContinuous() 为真时才可把全部元素当一段线性内存遍历。clone() 可获得独立连续副本，但会产生一次完整拷贝。〔S14〕", size: 9.5pt)
  #raw("cv::Mat roi = image(rect); // 通常仅新建头，仍沿用父图 stride\nfor (int y = 0; y < roi.rows; ++y) {\n    const auto *row = roi.ptr<std::uint8_t>(y);\n    processRow(row, static_cast<std::size_t>(roi.cols) * roi.elemSize());\n}\nif (!roi.isContinuous()) handleRowsSeparately(); // 不可当成单段内存\ncv::Mat packed = roi.clone(); // 需要连续独立存储时付出一次复制\n// step 描述行间距，不能只用 cols 推出下行地址", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("025  相机标定要估计哪些参数？基本流程是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  用棋盘格或 Charuco 等已知几何图案拍摄多个位置、倾角和距离的图像，检测角点后以 calibrateCamera 联合估计内参矩阵 fx、fy、cx、cy、畸变系数，以及每张图相对标定板的旋转和平移。观察重投影误差并剔除模糊/重复视角；之后可用 undistort 去畸变。图案实际尺寸影响尺度换算，但内参质量更依赖覆盖全画面和姿态多样性。〔S14〕", size: 9.5pt)
  #raw("// 每个视角保存同一标定板的已知点与检测角点\nstd::vector<std::vector<cv::Point3f>> objectPoints;\nstd::vector<std::vector<cv::Point2f>> imagePoints;\ncv::Mat cameraMatrix, distortion; std::vector<cv::Mat> rvecs, tvecs;\nconst double rms = cv::calibrateCamera(objectPoints, imagePoints, imageSize,\n    cameraMatrix, distortion, rvecs, tvecs);\nif (!std::isfinite(rms)) return reportCalibrationFailure();\ncv::undistort(testImage, corrected, cameraMatrix, distortion);\n// 多姿态覆盖全画面；模糊/重复视角剔除", lang: "cpp", block: true)
]

#heading(level: 1, outlined: true)[#text("第16章 音视频与 FFmpeg", size: 15pt, weight: "bold", fill: rgb("#000000"))]
#heading(level: 2, outlined: true)[#text("16.1 容器、编码与流媒体协议", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("001  AAC编码的ADTS和ADIF格式有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  ADTS 通常在每个 AAC access unit 前附带同步头、采样率索引和帧长等信息，接收端可从流中逐帧找边界；ADIF 把头信息集中放在文件开头，适合已知完整文件而不利于从中间随机同步。两者是 AAC 的传输封装形式，不能据此判断编码质量，也不能简单互换扩展名。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("002  AVFormatContext、AVCodecContext、AVStream的作用分别是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  AVFormatContext 代表输入或输出容器，维护文件 I/O、时长和流列表；AVStream 描述其中一条音视频流及其时间基和 AVCodecParameters。AVCodecContext 是具体解码器/编码器的运行配置与状态，打开 codec 后参与处理。解码时通常从 codecpar 复制参数到 context，不能把 Stream 本身当作解码器。", size: 9.5pt)
  #raw("AVFormatContext *format = nullptr;\nif (avformat_open_input(&format, path, nullptr, nullptr) < 0) return;\nif (avformat_find_stream_info(format, nullptr) < 0) {\n    avformat_close_input(&format); return reportProbeError();\n}\nint index = av_find_best_stream(format, AVMEDIA_TYPE_VIDEO, -1, -1, nullptr, 0);\nif (index >= 0) {\n    AVStream *stream = format->streams[index]; // 容器中的轨道/时间基\n    AVCodecContext *codec = avcodec_alloc_context3(decoder);\n    avcodec_parameters_to_context(codec, stream->codecpar); // 配置解码状态\n    if (avcodec_open2(codec, decoder, nullptr) >= 0) decode(codec);\n    avcodec_free_context(&codec);\n}\navformat_close_input(&format); // 成功打开后的所有出口都关闭", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("003  AVPacket和AVFrame有什么区别？分别存储什么数据？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  AVPacket 通常保存压缩码流引用、所属流索引和 PTS/DTS 等时间信息，供解码器接收或由编码器产生；AVFrame 保存解码后的图像平面或音频样本，编码前也把它作为输入。一个 packet 不保证恰好对应一个可显示 frame，解码还可能延迟。用 av_packet_unref/av_frame_unref 复用释放引用，避免泄漏。", size: 9.5pt)
  #raw("AVPacket *packet = av_packet_alloc(); // 压缩码流及 stream_index/时间戳\nAVFrame *frame = av_frame_alloc(); // 解码后的平面图像或音频样本\nwhile (av_read_frame(format, packet) >= 0) {\n    if (packet->stream_index == videoIndex) sendAndReceive(decoder, packet, frame);\n    av_packet_unref(packet); // 释放 packet 持有的数据引用\n}\nav_frame_unref(frame); // 可复用 frame 时释放本轮缓冲引用\nav_packet_free(&packet); av_frame_free(&frame); // 释放对象本身\n// 一个 packet 不保证只产出一帧；decoder 可能缓存延迟帧", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("004  FFmpeg的主要组件有哪些？各自的作用是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  libavformat 负责读写容器和解复用/复用，libavcodec 提供编解码器，libavutil 提供时间、内存、日志等基础设施；libswscale 做图像缩放和像素格式转换，libswresample 做音频重采样。另有 libavfilter 处理滤镜图、libavdevice 接入采集设备。构建时可裁剪组件，程序应检查实际编译启用的格式和编码器。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("005  FLV文件格式的特点是什么？FLV Tag的类型有哪些？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  FLV 文件由标记 FLV 的文件头和一系列 Tag 组成，每个 Tag 带类型、数据长度、时间戳及流 ID，后接 PreviousTagSize 便于定位。常见 Tag 是音频、视频和脚本数据，脚本数据常携带 onMetaData。Tag 内部的音视频编码格式仍由 codec 标识，不能仅凭 FLV 容器名判断实际编码。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("006  H.264和H.265的主要区别是什么？压缩效率和编码复杂度如何对比？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  H.265/HEVC 使用更灵活的编码树块、预测和变换结构，相比 H.264 常能以较低码率达到相近主观质量；收益随内容、分辨率、编码器和参数而变，不能保证固定节省比例。HEVC 编码通常更耗计算，解码硬件与终端兼容面也须确认；若播放端不支持，较高压缩率没有实际收益。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("007  H.264的Profile和Level分别代表什么含义？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Profile 规定可使用的编码工具与能力子集，例如 Baseline、Main、High；Level 限定最大处理能力，如图像尺寸、宏块率、码率和解码缓冲要求。设备要同时满足 profile、level 和实际像素格式、分辨率、帧率组合。标记高 level 并不会提升画质，只表示码流可能需要更强解码能力。", size: 9.5pt)
  #raw("AVCodecContext *encoder = avcodec_alloc_context3(codec);\nencoder->width = width; encoder->height = height;\nencoder->pix_fmt = AV_PIX_FMT_YUV420P; encoder->time_base = AVRational{1, 30};\nencoder->profile = FF_PROFILE_H264_HIGH; // 工具集子集\nencoder->level = 40; // 约束能力上限，数值按 codec 定义\nif (avcodec_open2(encoder, codec, nullptr) < 0) reportUnsupportedConfig();\navcodec_free_context(&encoder);\n// 还要验证目标设备能解该 profile/level/尺寸/帧率组合", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("008  HLS协议的原理是什么？M3U8文件的作用是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  HLS 将媒体切为若干分片，由 M3U8 播放列表给出分片 URI、时长、序号及可选的多码率变体；客户端按列表缓冲播放，并可依带宽切换变体。分片常用 MPEG-TS 或 fMP4，直播列表会周期更新。分片时长、关键帧边界、缓存策略共同决定切换和端到端延迟。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("009  IDR帧和I帧有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  I 帧的图像内容不依赖其他帧，可独立解码；H.264 的 IDR 是一种特殊的 I 图像，会标记参考图像状态刷新，使其后的图像不再引用 IDR 前的参考帧。普通 I 帧可能出现在开放 GOP 中，后续帧仍可能依赖之前图像，因此 seek、分段和错误恢复时应识别真正的随机访问点。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("010  MP4文件的基本结构是怎样的？什么是moov、mdat、ftyp？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  MP4/ISO BMFF 由层级化 box 组成：ftyp 描述品牌及兼容标识，mdat 存放实际媒体样本，moov 保存轨道、时序、编解码配置和样本索引。moov 若在文件尾，播放端可能先需下载较多数据才能开始；faststart 重排可把 moov 移到前部，但大文件重排会涉及文件读写。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("011  RTMP协议的特点是什么？适用于什么场景？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  RTMP 常用于采集端向服务器推送直播流，基于 TCP，默认常用端口 1935，并以握手、chunk 和多路复用消息传输音视频；TCP 保证字节流有序，但重传和队头阻塞会增加时延，延迟取决于缓冲配置与网络。RTMPS 通常在 RTMP 上使用 TLS；浏览器播放通常会转成 HLS/DASH 或 WebRTC。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("012  RTP和RTCP分别是什么？它们在流媒体传输中的作用是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  RTP 在实时媒体包中带序列号、采样时钟时间戳和负载类型，帮助接收端重排、检测丢包并按媒体时钟播放；它通常运行于 UDP，不保证送达。RTCP 配套交换发送/接收报告、丢包和抖动统计及 NTP/RTP 时钟映射，可用于音视频同步和拥塞控制反馈，但自身不负责重传保证。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("013  RTSP协议的工作流程是什么？主要包含哪些命令？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  客户端通常先 OPTIONS 查询能力，再 DESCRIBE 获取 SDP，之后 SETUP 协商传输方式和端口，PLAY 开始播放；可用 PAUSE 暂停，最终 TEARDOWN 结束会话。RTSP 是会话控制协议，媒体多数经 RTP/RTCP 传输，也可交织在 TCP 中；实际命令顺序会随服务器能力和认证流程变化。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("014  SwrContext的作用是什么？如何使用它进行音频重采样？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  SwrContext 是 libswresample 的转换状态，可在采样率、样本格式或声道布局不同的输入输出间重采样。先按输入输出参数配置并初始化，再逐帧传入平面数据及 linesize，按 swr_get_out_samples/延迟估算提供足够输出空间；转换量可能少于输入量。收尾时以空输入持续调用 swr_convert 取出滤波器尾部延迟样本。", size: 9.5pt)
  #raw("SwrContext *swr = nullptr;\ncheck(swr_alloc_set_opts2(&swr, &outLayout, AV_SAMPLE_FMT_S16, 44100,\n                          &inLayout, AV_SAMPLE_FMT_FLTP, 48000, 0, nullptr));\ncheck(swr_init(swr)); // 参数在初始化前确定\nint capacity = swr_get_out_samples(swr, input->nb_samples);\nallocateOutputPlanes(capacity, outLayout);\nint samples = swr_convert(swr, output, capacity, input->extended_data, input->nb_samples);\nwriteSamples(output, samples); // 输出数与输入数可不同\nint tail = swr_convert(swr, output, capacity, nullptr, 0); // 取滤波器尾部\nfreeOutputPlanes(); av_channel_layout_uninit(&inLayout); av_channel_layout_uninit(&outLayout); swr_free(&swr);", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("015  SwsContext的作用是什么？如何使用它进行YUV到RGB的转换？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  SwsContext 保存像素格式转换和缩放配置，可由 sws_getContext 创建，再用 sws_scale 按输入平面指针、行跨度和行范围转换；例如 YUV420P 转 RGB24 时必须传对 Y/U/V plane 与 linesize。还要确认 BT.601/709 等矩阵以及 full/limited range，色彩元数据不一致会导致偏色或黑位发灰。", size: 9.5pt)
  #raw("SwsContext *sws = sws_getContext(srcW, srcH, AV_PIX_FMT_YUV420P,\n    dstW, dstH, AV_PIX_FMT_RGB24, SWS_BILINEAR, nullptr, nullptr, nullptr);\nif (!sws) return reportAllocationFailure();\nallocateRgbFrame(dstW, dstH, &dstData, &dstStride); // 含 padding\nsws_scale(sws, src->data, src->linesize, 0, srcH, dstData, dstStride);\n// 输入 plane 指针和每行 stride 必须来自 AVFrame\nconst int *matrix = sws_getCoefficients(SWS_CS_ITU709);\nsws_setColorspaceDetails(sws, matrix, 0, matrix, 1, 0, 1 << 16, 1 << 16);\nfreeRgbFrame(&dstData); sws_freeContext(sws); // 同时释放源/目标 AVFrame", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("016  UDP和TCP在流媒体传输中各有什么优缺点？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  TCP 提供可靠、有序字节流，丢包时重传且后续数据会被队头阻塞，适合容忍缓冲的传输；UDP 开销低、可独立处理丢失和过期包，但不保证送达、顺序，也不会自动控制拥塞。实时 RTP/UDP 可结合 NACK、FEC 和抖动缓冲恢复；选择取决于时延预算、网络策略与应用层机制。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("017  WebRTC的主要特点是什么？适用于什么场景？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  WebRTC 面向端到端实时通信，通常支持媒体采集、回声消除、降噪、拥塞控制、加密及音视频同步。ICE 利用候选地址建立连通，STUN 辅助发现公网映射，TURN 在直连失败时中继；应用仍需自行提供信令交换 SDP/候选信息。典型场景是通话和互动直播，网络穿透与服务部署会影响成本。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("018  YUV420P、YUV420SP（NV12、NV21）的数据排列方式有何不同？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  YUV420P/I420 有独立的 Y、U、V 三个平面，U/V 分辨率各约为宽高一半；NV12 是 Y 平面加交错 UV 色度平面，NV21 则交错 VU。它们在相同采样下色度信息量接近，但内存布局不同，不能当作相同格式直接传给解码器或纹理；各平面的 stride 也可能有对齐填充。", size: 9.5pt)
  #raw("// planar YUV420P：Y、U、V 独立 plane\nconst std::uint8_t *y = frame->data[0], *u = frame->data[1], *v = frame->data[2];\nconst int yStride = frame->linesize[0], uStride = frame->linesize[1];\nsamplePlanar(y, u, v, yStride, uStride);\n// semiplanar NV12：data[1] 内 UV 交错；NV21 为 VU\nconst std::uint8_t *uv = nv12->data[1];\nsampleInterleavedUv(uv, nv12->linesize[1]);\n// 每行用 stride 前进；plane 次序不符会出现明显偏色", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("019  YUV420、YUV422、YUV444的区别是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  4:4:4 中每个亮度样本对应一个 U、V 样本；4:2:2 每两个水平方向亮度样本共享一组色度；4:2:0 再在垂直方向也约减半。抽样减少色度带宽和存储，通常对人眼影响较小，但会损失彩色边缘细节。采样比例说明分辨率关系，平面或交错排列则由具体 pixel format 决定。", size: 9.5pt)
  #raw("const std::size_t y = static_cast<std::size_t>(width) * height;\nconst std::size_t cw = (width + 1) / 2, ch = (height + 1) / 2;\nconst std::size_t bytes420 = y + 2 * cw * ch; // U/V 向上取整\nconst std::size_t bytes422 = y + 2 * cw * height;\nconst std::size_t bytes444 = 3 * y;\n// 采样越稀，色度边缘细节越少；实际 frame 还有 stride padding\nreport(bytes420, bytes422, bytes444);", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("16.2 FFmpeg 解复用、解码与时间戳", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("020  av_read_frame()读取的是什么数据？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  av_read_frame(fmt, pkt) 从解复用器读取下一个压缩 packet，成功返回 0，EOF 返回 AVERROR_EOF，其他负值表示错误；packet 的 stream_index 区分音频、视频或字幕，时间戳以对应 AVStream 的 time_base 表示。它不负责解码，数据也未必与单个画面一一对应。处理后调用 av_packet_unref 释放其引用。", size: 9.5pt)
  #raw("AVPacket *packet = av_packet_alloc();\nif (!packet) return reportAllocationFailure();\nwhile ((ret = av_read_frame(format, packet)) >= 0) {\n    const AVStream *stream = format->streams[packet->stream_index];\n    if (packet->stream_index == videoIndex) decode(packet); // 仍是压缩 packet\n    inspect(packet->pts, packet->dts, stream->time_base);\n    av_packet_unref(packet); // 每次读完都归还 payload 引用\n}\nif (ret != AVERROR_EOF) report(ret); // 区分读错误与正常结束\nav_packet_free(&packet); // 再释放 packet 对象", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("021  av_rescale_q()函数的作用是什么？如何进行时间戳转换？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  av_rescale_q(a, bq, cq) 计算与 a×bq/cq 等价的有理数缩放，并做舍入与溢出保护，把以 bq 为单位的时间戳转成 cq 单位。例如流时间基 1/90000 转到编码器 1/25，应以 rescale_q 将输入 PTS 换成编码器刻度。传参时先确认源、目标 time_base 次序，不能把分子分母倒置。", size: 9.5pt)
  #raw("if (pts != AV_NOPTS_VALUE) {\n    const AVRational streamTb = stream->time_base; // 源时间刻度\n    const AVRational encoderTb{1, 25}; // 目标每帧 1/25 秒\n    const std::int64_t encoderPts = av_rescale_q(pts, streamTb, encoderTb);\n    submitTimestamp(encoderPts); // 先确认 bq/cq 次序\n}\n// 不要直接把 PTS 当毫秒；有理数缩放还可避免乘法溢出", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("022  avcodec_send_packet()和avcodec_receive_frame()的作用是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  send_packet 把压缩包送入解码器，receive_frame 应循环取出当前所有可用帧；send 返回 EAGAIN 时先 receive 至 EAGAIN，再重送同一 packet；receive 返回 EAGAIN 则继续供包。输入 EOF 后发送一次 NULL flush，再持续 receive 到 AVERROR_EOF，取完延迟帧；EAGAIN 是状态切换信号，不是解码错误。", size: 9.5pt)
  #raw("// receiveAvailable 循环 receive_frame：处理每帧并 unref，直到 EAGAIN/EOF\nint ret = avcodec_send_packet(decoder, packet);\nif (ret == AVERROR(EAGAIN)) { receiveAvailable(decoder, frame); ret = avcodec_send_packet(decoder, packet); }\nif (ret < 0) return reportDecodeError(ret);\nreceiveAvailable(decoder, frame); // receive 到 EAGAIN 后再送下一包\n// demux EOF 后发送空包进入 draining mode\nwhile ((ret = avcodec_send_packet(decoder, nullptr)) == AVERROR(EAGAIN)) receiveAvailable(decoder, frame);\nif (ret >= 0) receiveUntil(decoder, frame, AVERROR_EOF);\n// 最终 av_packet_free、av_frame_free、avcodec_free_context", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("023  time_base是什么？如何理解时间戳和time_base的关系？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  time_base 是有理数形式的时钟刻度，例如 1/90000 表示一个 timestamp 单位为 1/90000 秒；实际秒数为 timestamp×time_base。不同流、解码器和编码器可使用不同刻度，必须通过 av_rescale_q 转换。帧率不是时间基的同义词，B 帧或可变帧率视频的展示时刻应以 PTS 为准。", size: 9.5pt)
  #raw("const AVRational tb = stream->time_base; // 每个 timestamp 的秒数\nif (frame->pts != AV_NOPTS_VALUE) {\n    const double seconds = frame->pts * av_q2d(tb);\n    showAt(seconds); // 展示时钟使用 PTS\n}\nconst AVRational ms{1, 1000};\nconst std::int64_t timestampMs = av_rescale_q(frame->pts, tb, ms);\n// time_base 不是帧率；不同流刻度不可直接比较", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("024  什么是I帧、P帧、B帧？它们在视频编码中的作用和压缩率有何不同？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  I 帧不依赖其他图像可独立重建，P 帧主要引用先前参考图像，B 帧可依据前后参考图像作双向预测；现代标准还可使用多参考等结构。帧间预测通常省码率，却让显示顺序和解码顺序不同，并带来重排延迟。随机访问通常从 IDR/其他可恢复点进入，再解码后续依赖帧。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("025  什么是NAL Unit？H.264码流的基本结构是怎样的？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  NAL Unit 是 H.264 基本码流单元，由 NAL 头和负载构成；负载可为切片、SPS/PPS 参数集、SEI 等。裸流常以 Annex B 的 00 00 01/00 00 00 01 起始码分隔，MP4 等容器通常用 AVCC 长度前缀，并将参数集另存配置记录。送入不同协议前应按需做 bitstream filter 转换。", size: 9.5pt)
  #raw("const AVBitStreamFilter *filter = av_bsf_get_by_name(\"h264_mp4toannexb\");\nAVBSFContext *bsf = nullptr; check(av_bsf_alloc(filter, &bsf));\navcodec_parameters_copy(bsf->par_in, stream->codecpar); bsf->time_base_in = stream->time_base;\ncheck(av_bsf_init(bsf)); // MP4 length-prefix 转 Annex B 起始码\ncheck(av_bsf_send_packet(bsf, packet)); // 成功后 packet 内容所有权转移\nwhile (av_bsf_receive_packet(bsf, filtered) == 0) writeAnnexB(filtered);\nav_packet_free(&packet); av_packet_free(&filtered); av_bsf_free(&bsf);\n// 参数集和 NAL 格式按目标协议/容器选择", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("026  什么是PCM（脉冲编码调制）？采样率、位深度、声道数分别代表什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  PCM 直接表示采样后的离散幅值，未做感知有损压缩。采样率是每秒采样次数，位深描述每个样本的量化位数，声道数表示独立信号路数；未压缩数据率可估为采样率×位深×声道数，单位 bit/s。实际还要考虑 packed/planar 布局、对齐及容器头，不能仅靠文件扩展名推断参数。", size: 9.5pt)
  #raw("const std::uint64_t bitsPerSecond =\n    static_cast<std::uint64_t>(sampleRate) * bitsPerSample * channels;\nconst std::size_t bytesPerSecond = static_cast<std::size_t>((bitsPerSecond + 7) / 8);\nconst std::size_t blockBytes = bytesPerSecond * blockMilliseconds / 1000;\nreadPcmBlock(buffer, blockBytes);\nplaySamples(buffer, sampleRate, sampleFormat, channels);\n// PCM 无自描述头：调用方须知道位深/浮点格式与 packed/planar 布局\n// 容器头、对齐与设备缓冲还会增加字节数", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("027  什么是PTS和DTS？为什么需要两个时间戳？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  DTS 表示压缩帧应送去解码的时间，PTS 表示解码后应呈现的时间；没有帧重排时二者常接近，有 B 帧时解码顺序与显示顺序不同，二者便不同。时间戳单位由流的 time_base 决定，可能缺失为 AV_NOPTS_VALUE；音视频同步应把有效 PTS 转成共同时钟再比较。", size: 9.5pt)
  #raw("if (packet->dts != AV_NOPTS_VALUE)\n    decoderOrderClock = av_rescale_q(packet->dts, stream->time_base, commonTb);\nif (frame->pts != AV_NOPTS_VALUE)\n    displayClock = av_rescale_q(frame->pts, stream->time_base, commonTb);\n// 有 B 帧时解码次序和显示次序不同，DTS/PTS 不同\nif (frame->pts == AV_NOPTS_VALUE) useFallbackTimestamp();\n// 同步音视频前先把有效时间戳换到共同时钟", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("16.3 图像、音频与视频编码原理", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("028  什么是SIMD？如何使用SIMD优化视频处理？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  SIMD 让一条向量指令同时处理多个像素或样本，例如并行做颜色转换、阈值和卷积。先用连续数据、减少分支并检查编译器自动向量化；热点明确后再考虑 SSE/AVX/NEON intrinsics 或已有优化库。需处理尾部不足一个向量的元素和对齐，且内存带宽、缓存与数据搬运常比算术指令更先成为瓶颈。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("029  什么是YUV颜色空间？YUV和RGB有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  RGB 用三原色通道直接描述显示颜色；视频常用 Y′CbCr，将伽马校正后的亮度分量与色度差分开，便于降低色度采样率。工程接口常把 Y′CbCr 俗称 YUV，但模拟 YUV 与数字 YCbCr 概念不同。转换必须匹配 BT.601/709/2020 矩阵和全/限幅范围，否则会出现色偏、黑白位不正确。", size: 9.5pt)
  #raw("SwsContext *convert = makeYuvToRgbContext(frame->width, frame->height);\nconst int *coeff = sws_getCoefficients(SWS_CS_ITU709); // 色彩矩阵\nsws_setColorspaceDetails(convert, coeff, sourceIsFullRange,\n                         coeff, 1, 0, 1 << 16, 1 << 16);\nsws_scale(convert, frame->data, frame->linesize, 0, frame->height, rgb, stride);\nshowRgb(rgb); // 亮度/色度通过矩阵组合到 RGB\nsws_freeContext(convert); // 同时检查 source range/full vs limited metadata", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("030  什么是丢包（Packet Loss）？如何处理丢包问题？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  丢包指传输中的媒体包未到达或未能按时使用，可从 RTP 序列号缺口、RTCP 统计和解码错误观测。可按剩余播放时限尝试 NACK 重传、前向纠错、PLC/帧隐藏或丢弃受损参考链并请求关键帧；实时流不能盲目无限等待。网络拥塞应结合降码率和有界缓冲处理，避免重传加剧排队。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("031  什么是关键帧间隔？如何设置合适的关键帧间隔？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  关键帧间隔表示随机访问点之间的帧数或时间，常与 GOP 长度相关。间隔短可缩短 seek/直播切入等待并加快错误恢复，但关键帧较大，可能抬高码率；间隔长通常压缩更有效，却让客户端等待更久。直播分片常要求关键帧与分片边界对齐，帧率可变时应按时间而非只按帧数校准。", size: 9.5pt)
  #raw("encoder->time_base = AVRational{1, fps};\nencoder->framerate = AVRational{fps, 1};\nencoder->gop_size = fps * targetKeyframeSeconds; // 近似按秒设随机访问间隔\nencoder->max_b_frames = 0; // 低延迟场景可减少重排\nif (avcodec_open2(encoder, codec, nullptr) < 0) reportUnsupportedSettings();\n// 分片直播常要求关键帧与切片边界对齐\n// 短 GOP 提高恢复频率，也可能增加码率", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("032  什么是分辨率（Resolution）？常见的视频分辨率有哪些？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  分辨率是编码帧的样本宽高，如 1920×1080；p 常指逐行扫描标识，而不只是清晰度等级。480p、720p、1080p、UHD 4K 3840×2160 是常见档位，但 SD/2K/4K 命名存在地区和影院标准差异。像素尺寸不等于显示宽高比，非方形像素素材还需结合 SAR/PAR。", size: 9.5pt)
  #raw("encoder->width = 1920; encoder->height = 1080; // 编码样本宽高\nencoder->sample_aspect_ratio = AVRational{1, 1}; // 方形像素\nstream->sample_aspect_ratio = encoder->sample_aspect_ratio;\nstream->avg_frame_rate = AVRational{30, 1};\nconst AVRational dar = av_mul_q(\n    av_mul_q(AVRational{encoder->width, encoder->height}, encoder->sample_aspect_ratio),\n    AVRational{1, 1});\nlogDisplayRatio(av_q2d(dar)); // 还需结合目标显示像素比例\n// p 通常描述逐行扫描；分辨率不等于显示宽高比", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("033  什么是去块效应滤波（Deblocking Filter）？为什么需要它？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  去块滤波在重建块边界附近按运动、量化强度和边缘特征自适应平滑，减少低码率下明显的方块接缝。它通常嵌入编码标准解码流程，滤波后的重建帧还可能用于后续预测参考；关闭会改变解码画面并影响码流兼容预期。过度平滑也会损失细节，因此不是简单对全图做模糊。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("034  什么是宏块（Macroblock）？H.264中宏块的大小是多少？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  H.264 的宏块亮度基本尺寸为 16×16，色度块大小由 4:2:0、4:2:2 等抽样格式决定；宏块可分成更小分区用于运动预测，也可细分变换块。它是编码结构单位，不表示一帧被划成固定不变的方格。H.265 采用更大的 CTU 及递归编码树划分，结构更灵活。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("035  什么是容器格式？容器格式和编码格式有什么关系？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  容器是媒体文件的组织格式，例如 MP4、MKV，负责将轨道、时间戳、索引、元数据和压缩数据封装在一起；编码格式如 H.264、AV1、AAC 决定媒体如何压缩。一个容器可以装多种编码，但容器支持不代表目标播放器支持其中每种 codec、profile 或像素格式。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("036  什么是宽高比（Aspect Ratio）？像素宽高比（PAR）和显示宽高比（DAR）有什么关系？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  PAR 是单个像素的显示宽高比；SAR 在视频术语中常指样本宽高比，即帧的像素宽高比 W/H；DAR 是最终画面的显示宽高比，关系为 DAR = SAR×PAR。术语在不同文档中 SAR 也可能被写作 sample aspect ratio，需结合上下文。若忽略非方形像素，画面会被拉伸或压扁。", size: 9.5pt)
  #raw("const AVRational sar = stream->sample_aspect_ratio.num\n    ? stream->sample_aspect_ratio : AVRational{1, 1};\nconst AVRational display = av_mul_q(\n    AVRational{stream->codecpar->width, stream->codecpar->height}, sar);\nconst double dar = av_q2d(display); // sample aspect × pixel aspect\nsetDisplayViewport(dar);\n// 元数据缺失时可用 1:1 假设；术语 SAR/PAR 在文档间可能混用\n// 不能只凭像素矩形推断最终显示比例", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("037  什么是封装器（Muxer）和解封装器（Demuxer）？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Muxer 把编码后的 packet、时间戳和轨道元数据写入 MP4 等容器，并建立索引；demuxer 解析容器，输出各流压缩 packet 和时间信息。二者通常不做像素级解码或重编码，因而可用于无损转封装。更换不兼容编码时仍需解码、必要滤镜处理并重新编码。", size: 9.5pt)
  #raw("// Demux：av_read_frame 取压缩 packet，不解码像素\nwhile (av_read_frame(input, packet) >= 0) {\n    const int i = packet->stream_index;\n    packet->stream_index = mapInputToOutput(i);\n    av_packet_rescale_ts(packet, input->streams[i]->time_base,\n                         output->streams[packet->stream_index]->time_base);\n    av_interleaved_write_frame(output, packet); // Mux 到新容器\n}\nav_write_trailer(output); // 写索引/尾部元数据\n// stream copy 适用于目标容器支持 codec；按顺序关闭 AVIO/context", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("038  什么是帧内预测和帧间预测？分别采用什么技术实现？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  帧内预测只利用当前帧已重建的邻近像素，按方向或平面模式预测当前块；帧间预测从一幅或多幅参考帧中用运动矢量取样，再做运动补偿。编码器对原块和预测块之差形成残差，经过变换、量化和熵编码；解码器按相同步骤恢复，因此参考帧必须先正确重建。 帧内模式在切换场景或随机访问时有用，但一般比有效帧间预测消耗更多码率。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("039  什么是帧率（Framerate）？常见的帧率有哪些？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  帧率是单位时间内显示或采集的帧数，常见电影 24、视频 25/30、运动内容 50/60 fps。固定帧率可由相邻帧 PTS 间隔推得；可变帧率应读取每帧时间戳，不能只拿标称平均帧率计算。提高帧率会增加处理、传输和存储压力，也要求快门与显示设备配合。", size: 9.5pt)
  #raw("encoder->time_base = AVRational{1, 30}; // 每帧时钟单位\nfor (std::int64_t index = 0; index < frameCount; ++index) {\n    frame->pts = index; // 固定帧率按编码器时间基递增\n    int ret = avcodec_send_frame(encoder, frame);\n    if (ret == AVERROR(EAGAIN)) {\n        receivePacketsUntilEagain(encoder, packet);\n        ret = avcodec_send_frame(encoder, frame); // 重送尚未接收的帧\n    }\n    check(ret); receivePacketsUntilEagain(encoder, packet);\n}\nsendNullFrameRetryingEagain(encoder, packet); // 输入结束后发送空帧\nreceivePacketsUntil(encoder, packet, AVERROR_EOF); // 取完延迟输出\n// 可变帧率按源 PTS 换算；最后释放 packet/frame/context", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("040  什么是抖动（Jitter）？如何处理网络抖动？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  网络抖动是包到达时延或间隔的变化，可由 RTP 到达间隔统计并通过 RTCP 报告。接收端 jitter buffer 先缓存并按 RTP 时间戳平滑输出，太小会欠载、太大则增加端到端延迟；可自适应调整目标缓冲并丢弃已过期包。它只能吸收有限波动，无法弥补长期带宽不足或严重丢包。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("041  什么是推流和拉流？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  推流是采集或生产端编码后向媒体服务器发送数据，拉流是客户端从服务器获取流并缓冲、解码和播放。RTMP 常用于推送，HLS 常用于大规模分发，WebRTC/SRT 可覆盖不同互动与传输需求；协议决定连接、重传和分片方式，最终延迟还受编码、GOP、服务器转发和播放器缓冲影响。", size: 9.5pt)
  #raw("AVFormatContext *input = nullptr;\nif (avformat_open_input(&input, pullUrl, nullptr, nullptr) < 0) return reportConnectError();\ncheck(avformat_find_stream_info(input, nullptr)); // 拉流后探测轨道\nAVFormatContext *output = createOutput(pushUrl); // 推流输出上下文\ncopyStreamParameters(input, output); // 协议/容器支持对应 codec 时可直通\nwriteHeader(output); pumpPackets(input, output); // 仍需有界缓存\nwriteTrailer(output); closeOutput(output);\navformat_close_input(&input); // 端到端延迟还取决于 GOP/播放缓冲", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("042  什么是比特流（Bitstream）？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  比特流是编码器输出的有序压缩数据及解码所需参数信息；例如 H.264 由 NAL 单元组成，包含图像切片和 SPS/PPS。裸 Annex B 数据以起始码分隔，AVCC 等形式使用长度前缀，MP4 则把样本放在容器结构中。处理时需区分 elementary stream 与容器 packet，避免把两种边界格式混用。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("043  什么是码率（Bitrate）？码率和视频质量有什么关系？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  码率是单位时间产生或传输的比特数，常用 kbit/s 或 Mbit/s；平均码率可粗略由文件大小×8/时长估算，但容器开销会影响结果。提高码率通常降低有损压缩失真，却不保证更好画质：编码器效率、QP/质量模式、分辨率、帧率、噪声和场景复杂度都会改变同码率效果。", size: 9.5pt)
  #raw("encoder->bit_rate = 2'000'000; // 目标平均码率示例\nencoder->rc_max_rate = 2'500'000; // 可选峰值上限\nencoder->rc_buffer_size = 1'000'000; // 缓冲预算由编码器解释\ncheck(avcodec_open2(encoder, codec, nullptr));\n// 提高码率通常减轻有损失真，但不保证质量单调\n// 内容复杂度、分辨率、帧率和编码模式共同影响效果", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("044  什么是硬件编解码？和软件编解码有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  硬件编解码借助 GPU 或 SoC 专用媒体单元完成压缩/解压，常降低 CPU 占用和功耗、提升并发吞吐；软件编解码易部署、算法和参数较灵活，也可在新标准上更快更新。使用硬件时要核对设备支持的 codec/profile/位深、驱动与 FFmpeg 构建，并计入硬件帧与系统内存间拷贝成本。", size: 9.5pt)
  #raw("AVHWDeviceType type = AV_HWDEVICE_TYPE_NONE;\nwhile ((type = av_hwdevice_iterate_types(type)) != AV_HWDEVICE_TYPE_NONE)\n    qInfo() << av_hwdevice_get_type_name(type); // 构建包含的接口\nAVBufferRef *device = nullptr;\nif (av_hwdevice_ctx_create(&device, AV_HWDEVICE_TYPE_CUDA, nullptr, nullptr, 0) < 0)\n    return openSoftwareDecoder(); // 设备/驱动不可用就回退\ncodec->hw_device_ctx = av_buffer_ref(device); // codec 持有自己的引用\nav_buffer_unref(&device); // decoder 关闭时释放 codec context\n// get_format 与目标硬件像素格式回调按设备配置", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("045  什么是编解码器（Codec）？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  Codec 是编码器/解码器及其遵循的压缩表示规则；H.264、HEVC、AV1 是视频编码标准，AAC、MP3、Opus 是音频编码。编码流通常放入 MP4、Matroska 等容器中传输和索引。名称相同也可能因 profile、level、位深、声道布局或授权支持而无法在目标设备播放。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("046  什么是色度采样？为什么要进行色度采样？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  色度抽样减少 Cb/Cr 等色度平面的空间分辨率，以利用视觉对亮度细节更敏感的特性减少存储和带宽。4:2:0、4:2:2、4:4:4 表示相对亮度的色度样本密度。抽样会影响字幕、细线和彩色边缘清晰度；转码还须指定采样位置、矩阵与范围，不能只看像素格式名字。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("047  什么是视频延迟（Latency）？如何降低延迟？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  端到端时延由采集、编码前缓冲、编码重排、网络排队/传输、播放器缓冲、解码和显示共同构成，应先逐段打点找主因。低时延可关闭 B 帧、缩短编码队列和 GOP、缩小抖动缓冲并丢弃过期帧；缓冲过小会更易卡顿，需在时延、画质和抗抖动间实测取舍。 可记录采集时间戳、解码完成和实际显示时刻，量化各段排队时间。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("048  什么是视频滤镜？常见的视频滤镜有哪些？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  滤镜是解码后的帧处理节点，可缩放、裁剪、旋转、去噪、调色、叠加图像或文字；FFmpeg 用 -vf 或 -filter_complex 把节点连接成图。滤镜可能改变像素格式、尺寸、帧率或 PTS，需保证连接格式兼容，并按预期顺序处理，例如先缩放再定位 overlay。", size: 9.5pt)
  #raw("AVFilterGraph *graph = avfilter_graph_alloc();\nAVFilterContext *src = nullptr, *scale = nullptr, *sink = nullptr;\nconst AVFilter *scaleFilter = avfilter_get_by_name(\"scale\");\ncheck(avfilter_graph_create_filter(&src, avfilter_get_by_name(\"buffer\"),\n                                   \"in\", bufferArgs, nullptr, graph));\ncheck(avfilter_graph_create_filter(&scale, scaleFilter, \"scale\",\n                                   \"1280:720\", nullptr, graph));\ncheck(avfilter_graph_create_filter(&sink, avfilter_get_by_name(\"buffersink\"),\n                                   \"out\", nullptr, nullptr, graph));\ncheck(avfilter_link(src, 0, scale, 0)); check(avfilter_link(scale, 0, sink, 0));\n// bufferArgs 应含 video_size、pix_fmt、time_base 与 pixel_aspect\ncheck(avfilter_graph_config(graph, nullptr)); // 之后送帧、取处理帧\navfilter_graph_free(&graph); // 每个负值返回都应清理 graph", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("049  什么是转封装（Transmuxing）？它和转码（Transcoding）有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  转封装只从容器中取出压缩 packet 再写入另一容器，常用 ffmpeg -i in.mkv -c copy out.mp4，速度快且避免重新压缩损失；但目标容器必须支持所含 codec 和参数。转码则需解码、滤镜处理并重编码，可改尺寸、格式和码率，却更耗时且有损编码可能累积失真。", size: 9.5pt)
  #raw("// 转封装：只改 packet 容器，不解码重编码\nwhile (av_read_frame(input, packet) >= 0) {\n    mapStreamAndRescaleTimestamps(packet, input, output);\n    check(av_interleaved_write_frame(output, packet));\n    av_packet_unref(packet);\n}\nav_write_trailer(output); // 源 codec 必须受目标容器支持\n// 转码则是 send_packet -> receive_frame -> filter -> send_frame -> receive_packet\n// 改尺寸/采样格式需要转码，重编码可能引入失真", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("050  什么是运动补偿（Motion Compensation）？运动矢量在其中起什么作用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  运动补偿用参考图像按位移取出预测块，运动矢量描述该块相对当前块的位置差；编码器先做运动估计寻找候选矢量，再以运动补偿生成预测，编码矢量及原图与预测的残差。解码器按同一参考帧和矢量重建预测后加上残差；矢量不是物体真实运动轨迹。 现代编码还可插值到亚像素位置，提升预测匹配精度，但增加搜索成本。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("051  什么是音频帧？一帧音频包含多少个采样点？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  音频帧是 codec 的编码处理单位，包含多少采样点由编码标准、帧时长及配置决定。AAC-LC 常见 1024 个采样点，采样率 48 kHz 时约 21.33 ms；Opus 常用 2.5–60 ms 帧时长。PCM 没有统一 codec 帧边界，可按设备回调块组织；帧时长=样本数/采样率。", size: 9.5pt)
  #raw("if (frame->sample_rate > 0 && frame->nb_samples > 0) {\n    const AVRational sampleTb{1, frame->sample_rate};\n    const std::int64_t durationUs =\n        av_rescale_q(frame->nb_samples, sampleTb, AVRational{1, 1'000'000});\n    qInfo() << \"audio frame duration us\" << durationUs;\n}\n// nb_samples / sample_rate 才是音频帧时长\n// AAC/Opus 编码块大小不同；PCM 回调块不是 codec 固定帧", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("052  什么是音频重采样？在什么情况下需要进行重采样？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  重采样通过带限滤波和速率变换改变每秒采样数，也可连同样本格式或声道布局转换；例如将 48 kHz 立体声 float 转为 44.1 kHz 编码器要求的格式。转换会引入滤波延迟，需追踪输入样本数、输出数及缓存尾部；FFmpeg 可用 SwrContext，不能仅改采样率字段而不转换数据。", size: 9.5pt)
  #raw("SwrContext *swr = nullptr; // 改采样率/格式/声道布局\ncheck(swr_alloc_set_opts2(&swr, &stereo, AV_SAMPLE_FMT_S16, 44100,\n                          &inputLayout, AV_SAMPLE_FMT_FLTP, 48000, 0, nullptr));\ncheck(swr_init(swr)); // 不只是改 AVFrame 的 sample_rate 字段\nint capacity = swr_get_out_samples(swr, input->nb_samples);\nallocateOutput(capacity);\nint produced = swr_convert(swr, out, capacity, input->extended_data, input->nb_samples);\nconsume(out, produced); // 可能有滤波延迟\nint tail = swr_convert(swr, out, capacity, nullptr, 0); // flush 尾样本\nfreeOutput(); av_channel_layout_uninit(&stereo); av_channel_layout_uninit(&inputLayout); swr_free(&swr);", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("16.4 FFmpeg 编解码 API 流程", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("053  使用FFmpeg编码视频的基本流程是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先创建输出 AVFormatContext，选择流和编码器、设定尺寸/像素格式/time_base 并打开 codec，再写容器头。逐帧填 AVFrame、按时间顺序递增 PTS，调用 send_frame 后循环 receive_packet 直到 EAGAIN，换算 packet 时间戳到输出流 time_base 并 interleaved_write_frame。结束发送空帧 flush 收完 packet，写 trailer 后释放资源。", size: 9.5pt)
  #raw("// drainPackets 收到 EAGAIN 为止：换时基、mux 并 unref packet\ncheck(avcodec_open2(encoder, codec, nullptr)); check(avformat_write_header(output, nullptr));\nfor (std::int64_t i = 0; i < frameCount; ++i) {\n    frame->pts = i; // 按 encoder time_base 递增\n    int ret = avcodec_send_frame(encoder, frame);\n    if (ret == AVERROR(EAGAIN)) {\n        drainPackets(encoder, output, packet);\n        ret = avcodec_send_frame(encoder, frame); // 重送同一帧\n    }\n    check(ret); drainPackets(encoder, output, packet);\n}\nsendNullRetryingEagain(encoder, output, packet); // EOF 发送空帧\nreceiveAndMuxUntil(encoder, output, packet, AVERROR_EOF); av_write_trailer(output);\n// 释放 packet/frame/codec；avio_closep 后 avformat_free_context", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("054  使用FFmpeg解码视频的基本流程是什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先 avformat_open_input 并 find_stream_info，选择视频流，从 codecpar 配置并打开解码器。循环 av_read_frame，只把目标流 packet 送给解码器；send_packet 后持续 receive_frame 直至 EAGAIN，处理帧后及时 unref。读到 EOF 仍要发送空 packet 并取完延迟帧，最后释放 packet、frame、codec 和 format 上下文。", size: 9.5pt)
  #raw("// 已打开输入并用 codecpar 配置 decoder\nwhile (av_read_frame(format, packet) >= 0) {\n    if (packet->stream_index == videoIndex) {\n        int ret = avcodec_send_packet(decoder, packet);\n        if (ret == AVERROR(EAGAIN)) {\n            receiveAvailable(decoder, frame);\n            ret = avcodec_send_packet(decoder, packet); // 重送此包\n        }\n        check(ret); receiveAvailable(decoder, frame); // 到 EAGAIN\n    }\n    av_packet_unref(packet);\n}\nsendNullPacketRetryingEagain(decoder, frame); receiveUntilEof(decoder, frame); // EOF 取完延迟帧\n// av_packet_free、av_frame_free、avcodec_free_context、avformat_close_input", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("055  多线程在音视频处理中如何应用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  把解复用、解码、滤镜、编码和磁盘/网络 I/O 做成流水线，可让不同帧并行通过不同阶段；编解码库也可能内部使用帧/切片线程。线程间队列要有界并配背压，避免积压导致内存和延迟不断增长；正确传递引用计数帧、时间戳及 EOF/错误状态，性能应以端到端测量验证。", size: 9.5pt)
  #raw("// 每个 AVCodecContext 只由所属 stage 线程调用\nAVFrame *handoff = av_frame_clone(decoded); // 为消费者增加缓冲引用\nif (!handoff) reportOutOfMemory();\nif (!boundedQueue.tryPush(handoff)) { av_frame_free(&handoff); dropExpiredFrame(); }\n// queue 有容量上限；满时背压或丢过期实时帧\n// 消费者处理后 av_frame_free(&ownedFrame)，所有权在队列转移\n// EOF/错误也作为显式状态发送，时间戳随 frame 传递", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("16.5 命令行处理与播放器功能", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("056  如何从视频中提取音频？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  压缩音频与目标容器兼容时可直接抽流：ffmpeg -i input.mp4 -map 0:a:0 -vn -c:a copy audio.m4a；-map 可选指定第几条音轨，-vn 排除视频。若容器不支持源 codec 或需改采样率/质量，就指定 AAC 等编码器重编码。抽取不会把压缩音频还原成 PCM。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("057  如何使用FFmpeg命令行合并多个视频文件？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  无重编码拼接应使用 concat demuxer，而非泛称 concat 协议：清单写 file 'a.mp4'、file 'b.mp4'，再运行 ffmpeg -f concat -safe 0 -i list.txt -c copy out.mp4。各片段应有一致的流结构、codec、分辨率、time_base 等参数；不一致时先统一转码，或用 concat filter 解码拼接后重新编码。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("058  如何使用FFmpeg命令行将视频转换为GIF？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  可用 ffmpeg -i input.mp4 -t 5 -vf \"fps=10,scale=480:-1:flags=lanczos\" output.gif 限定时长、帧率与宽度；GIF 调色板最多 256 色，直接转码易出现色带。较好做法是先 palettegen 生成调色板，再 paletteuse 复用；透明度有限，复杂视频文件也容易很大。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("059  如何使用FFmpeg命令行工具进行视频转码？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  例如 ffmpeg -i in.mp4 -c:v libx264 -crf 23 -c:a aac out.mp4 会将视频用 x264 质量模式编码、音频转 AAC；CRF 是编码器特定参数，数值越低通常质量越高、文件越大，不保证固定码率。需按播放设备选择 yuv420p 等像素格式、profile 和分辨率，并可用 ffprobe 检查输出。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("060  如何使用FFmpeg命令行提取视频的第一帧？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  要取文件开头解码出的第一张图，可执行 ffmpeg -i input.mp4 -frames:v 1 first.jpg，输出帧会转为 JPEG 支持的像素格式。若要取指定时刻，使用 -ss；它放在 -i 前通常由 demuxer 快速跳到附近 seek point，转码时默认再解码丢弃到目标处， stream copy 则未必精确到帧。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("061  如何使用FFmpeg命令行给视频添加水印？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  图片水印可通过两路输入叠加：ffmpeg -i input.mp4 -i logo.png -filter_complex \"overlay=10:10\" -c:a copy out.mp4。滤镜会重编码视频，因此不能同时对视频做 -c:v copy；坐标基于输出帧左上角，可用表达式贴右下角，并确认透明通道、尺寸和输出编码器。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("062  如何使用FFmpeg命令行调整视频的分辨率？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  用 -vf \"scale=1280:-2\" 固定宽度并按原比例计算高度；-2 常用于让另一边自动取编码器常见的偶数尺寸。若直接写宽高会拉伸画面，可使用 force_original_aspect_ratio=decrease 后补边。缩放会重新编码视频，需决定 CRF/码率，并保留正确色彩矩阵、范围与 SAR。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("063  如何减少内存拷贝提升性能？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  复用 AVFrame/AVPacket 缓冲区、传递引用计数对象、减少不必要像素格式转换和重复 clone，可先消除常见 CPU memcpy；硬件链路可在解码、滤镜、编码间传递同一设备帧。先用 profiler 找到真实复制热点；所谓零拷贝仍需明确同步、背压、设备兼容和最后一个引用释放时机。", size: 9.5pt)
  #raw("AVFrame *shared = av_frame_clone(decoded); // 新 header，共享引用计数 AVBuffer\nif (!shared) return reportOutOfMemory();\nenqueueOwnedFrame(shared); // 队列拿到所有权，消费后 av_frame_free(&frame)\n// 修改前对共享帧调用 av_frame_make_writable()，可能触发复制\nif (av_frame_make_writable(shared) < 0) reportOutOfMemory();\nav_frame_free(&shared); // 释放本端引用，其他持有者仍有效\n// 零拷贝仍需同步、格式兼容和最后引用释放时机", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("064  如何判断一个视频文件是否包含音频流？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  可用 ffprobe -v error -select_streams a -show_entries stream=index -of csv=p=0 input.mp4，只选择音频流并列出索引；有一行输出表示至少有一条音频轨。程序中以返回码和解析到的 stream 数量判断，空输出可能代表无音频，也可能是探测失败或文件损坏，应区分错误。", size: 9.5pt)
  #raw("AVFormatContext *format = nullptr;\nif (avformat_open_input(&format, path, nullptr, nullptr) < 0) return reportProbeError();\nconst int probe = avformat_find_stream_info(format, nullptr);\nif (probe < 0) { avformat_close_input(&format); return reportProbeError(); }\nconst int audio = av_find_best_stream(format, AVMEDIA_TYPE_AUDIO, -1, -1, nullptr, 0);\nif (audio == AVERROR_STREAM_NOT_FOUND) reportNoAudioTrack();\nelse if (audio < 0) reportProbeError();\nelse reportAudioStream(format->streams[audio]);\navformat_close_input(&format); // 无音轨与探测失败是不同状态", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("065  如何在视频上添加水印？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  图片水印用 overlay，文字可用 drawtext；例如在滤镜图里指定 x/y、透明度和 enable 时间表达式。滤镜在解码帧上工作，因此视频要重新编码，音频通常可 -c:a copy 保留；文字滤镜还需字体配置，检查中文字体路径、输出分辨率变化和字幕坐标。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("066  如何处理视频文件的旋转信息？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先读取容器显示矩阵或旋转元数据，确认播放器是否已自动应用；若转码时再旋转一次会导致双重旋转。可将变换通过 transpose 等滤镜烘焙到像素并删除/重置旧矩阵，此时宽高可能互换，需同步更新尺寸、SAR 和定位；无损转封装时则需目标容器和播放器都支持该显示矩阵。", size: 9.5pt)
  #raw("std::size_t sideSize = 0;\nconst std::uint8_t *matrix = av_stream_get_side_data(stream, AV_PKT_DATA_DISPLAYMATRIX, &sideSize);\nif (matrix && sideSize >= 9 * sizeof(std::int32_t)) {\n    const double angle = av_display_rotation_get(\n        reinterpret_cast<const std::int32_t *>(matrix));\n    reportRotation(angle); // 先确认播放器是否已自动应用\n}\n// 转码烘焙 transpose 后清理旧显示矩阵，避免双重旋转\n// side data 指针属于 stream；复制前不要跨其生命周期保存", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("067  如何实现一个简单的PCM音频播放器？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  PCM 没有自描述头，播放器必须已知采样率、位深/浮点格式、声道数和交错布局；把读到的样本块送入 SDL 或系统音频 API。用有界环形缓冲区在 I/O 线程与音频回调间解耦，回调内避免阻塞和动态分配；播放进度按已消费样本数除以采样率计算。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("068  如何实现一个简单的YUV播放器？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  YUV 裸流没有头部，必须预先知道像素格式、宽高、帧率、平面排列和 stride；逐帧按各平面实际行跨度读取并送入渲染器。紧密排列且偶数宽高的 YUV420P 可按 Y=WH、U=V=WH/4 估算，每帧共 1.5WH 字节；有行对齐或奇数尺寸时不能直接用该公式。", size: 9.5pt)
  #raw("// 裸 YUV420P 没有头：宽高/格式/帧率由调用方给定\nconst int chromaW = (width + 1) / 2, chromaH = (height + 1) / 2;\nconst std::size_t yBytes = static_cast<std::size_t>(width) * height;\nconst std::size_t cBytes = static_cast<std::size_t>(chromaW) * chromaH;\nreadPlane(file, y, width, height, yStride); // 每行按 stride\nreadPlane(file, u, chromaW, chromaH, uStride);\nreadPlane(file, v, chromaW, chromaH, vStride);\nrenderer.uploadYuv420(y, u, v, width, height);\n// 紧密偶数尺寸才可简单算 1.5*W*H；处理 EOF/短读", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("069  如何实现视频截图功能？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  命令行可用 ffmpeg -ss 00:01:23 -i input.mp4 -frames:v 1 output.jpg 取目标附近的一帧，或用 -vf fps=1 每秒抽一张。输入侧 -ss 通常快速 seek 到前一个 seek point，转码时默认准确解码并丢弃之前帧；`-c copy` 无法保证精确到目标帧。批量截图还应控制输出命名和总帧数。", size: 9.5pt)
  #raw("const std::int64_t target = av_rescale_q(targetUs, AVRational{1, 1'000'000}, stream->time_base);\ndecoder->pkt_timebase = stream->time_base; // 解码输出时间戳刻度\ncheck(av_seek_frame(format, videoIndex, target, AVSEEK_FLAG_BACKWARD)); // 先到前一随机访问点\navcodec_flush_buffers(decoder); // 丢弃 seek 前解码器状态\nwhile (av_read_frame(format, packet) >= 0) {\n    if (packet->stream_index == videoIndex) decodeAndCheckPts(packet, target, frame);\n    av_packet_unref(packet); if (gotFrameAtOrAfterTarget) break;\n}\nconvertFrameToRgb(frame, image); // 保存单帧\n// 输入侧 seek 后还要解码到目标；失败出口释放 packet/frame/context", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("070  如何实现视频的倍速播放？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  视频倍速播放需把媒体时钟按播放速率推进，并将音频、视频 PTS 映射到同一播放时钟；视频可丢帧或重复帧来适配刷新率，音频可用 atempo 做保音高变速，简单重采样虽变速也会改音调。解码不足会欠载，倍速时还需限制队列并同步 seek/暂停状态。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("071  如何实现视频的快进和快退？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  快进通常 seek 到目标时间之前的随机访问点，再继续解码并丢弃目标之前的帧，才能得到依赖链完整且位置准确的画面；仅跳过 packet 可能造成花屏。快退可周期性 seek 到更早关键帧并正向解码目标 GOP，再缓存或倒序显示帧；长 GOP 会增加等待，音频需静音、反放或重新定位。", size: 9.5pt)
  #raw("const std::int64_t target = av_rescale_q(seekUs, AVRational{1, 1'000'000}, stream->time_base);\ndecoder->pkt_timebase = stream->time_base; // 解码输出时间戳刻度\ncheck(av_seek_frame(format, videoIndex, target, AVSEEK_FLAG_BACKWARD)); // seek 到关键帧附近\navcodec_flush_buffers(decoder); // 清空旧参考帧\nwhile (readVideoPacket(packet)) {\n    sendAndReceiveAll(decoder, packet, frame);\n    if (frame->pts != AV_NOPTS_VALUE && frame->pts >= target) display(frame);\n    av_packet_unref(packet); if (targetFrameReady) break;\n}\n// 快退可重复 seek 到更早 GOP 并缓存帧；直接跳 packet 会破坏依赖链\n// seek 后同步音频时钟；最终 free packet/frame/codec/format", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("072  如何实现视频的拼接和合并？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  首尾拼接参数相同的文件可用 concat demuxer 清单加 -c copy；concat 协议只是把文件字节顺序拼在一起，仅适用于支持这种物理拼接的少数容器。编码参数不同应把各输入解码后送入 concat filter，先统一画面尺寸、帧率、像素格式及音频采样率/布局，再输出并编码，否则滤镜输入会不兼容或产生时间跳变。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("073  如何实现视频的旋转？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  直角旋转可在转码滤镜中用 transpose=clock 或 transpose=cclock，具体方向可用测试帧确认；任意角度可用 rotate=角度表达式。旋转后画布默认策略可能裁切，应按角度计算输出宽高或显式设置 ow/oh，并处理填充颜色。若只改显示矩阵而不变换像素，则需考虑播放器兼容。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("074  如何实现视频的缩放？需要注意什么？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  使用 scale 滤镜或 libswscale 按目标尺寸缩放，保持显示宽高比时可固定一边并让另一边按比例计算，再选择插值算法。缩放前后要考虑 SAR/PAR、色度采样对偶数尺寸的要求和 BT.601/709 等色彩矩阵；更改像素格式或尺寸通常意味着重编码，需核验输出标签和实际像素一致。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("075  如何实现视频的裁剪？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  FFmpeg crop=w:h:x:y 从每帧左上角偏移 (x,y) 截取宽高为 w×h 的区域；例如 crop=iw/2:ih/2:iw/4:ih/4 截出原图中心半宽、半高的区域。坐标以输入帧为基准，须满足裁剪框在图像内；4:2:0 等色度抽样可能要求边界对齐到偶数，且裁切后视频需重编码。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("076  如何实现音视频的分离和合并？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  分离时可为输出加 -vn 或 -an，并在目标容器支持时用 -c copy 保留压缩流；选择多个输入中的哪条轨需显式 -map。合并独立音视频可写 ffmpeg -i v.mp4 -i a.aac -map 0:v:0 -map 1:a:0 -c copy out.mp4；若 codec、时间基或容器不兼容需转码，并确认起始时间偏移。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("077  如何提取视频的关键帧？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  ffprobe -select_streams v:0 -show_frames -show_entries frame=key_frame,best_effort_timestamp_time 可列出第一视频流各解码帧的关键帧标志与时间。提取时还需 seek 并解码到该时刻，而非直接把压缩 packet 当图像；编码类型的 key_frame 标志不总等同于 IDR，开放 GOP 还可能有前置依赖。", size: 9.5pt)
  #raw("// receive_frame 成功后处理，返回 EAGAIN 时送下一 packet\nwhile (decodeNextFrame(decoder, format, packet, frame)) {\n    if (frame->flags & AV_FRAME_FLAG_KEY) { // 帧标记不一定等于 H.264 IDR\n        convertToImage(frame, image);\n        saveImage(image, makeTimestampedPath(frame->pts));\n    }\n    av_frame_unref(frame); // 接收后复用前释放引用\n}\n// 真正随机访问还需 seek 到关键帧并解码依赖帧\n// 结束时 free frame/packet/codec/format", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("078  如何计算一帧YUV420P图像占用的内存大小？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  紧密排列、偶数宽高、8 位 planar YUV420P 的可见数据量为 WH + 2×(W/2)(H/2)=1.5WH 字节，例如 1920×1080 为 3,110,400 字节。AVFrame 实际分配按各 plane 的 linesize×plane 高度计算，stride 对齐会增加空间；奇数宽高时色度平面向上取整，须按格式规则计算。", size: 9.5pt)
  #raw("const std::size_t visibleY = static_cast<std::size_t>(width) * height;\nconst std::size_t chromaW = (width + 1) / 2, chromaH = (height + 1) / 2;\nconst std::size_t visible = visibleY + 2 * chromaW * chromaH; // Y/U/V\nconst std::size_t allocated =\n    static_cast<std::size_t>(std::abs(frame->linesize[0])) * height\n  + static_cast<std::size_t>(std::abs(frame->linesize[1])) * chromaH\n  + static_cast<std::size_t>(std::abs(frame->linesize[2])) * chromaH;\n// linesize 含对齐；这里只是可见容量 vs 常规 planar 分配估算", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("079  如何读取一个视频文件的基本信息（时长、分辨率、码率等）？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  ffprobe -v error -show_entries format=duration,bit_rate:stream=codec_type,width,height,r_frame_rate -of json input.mp4 可查看容器时长/码率和逐流尺寸、帧率等信息。分辨率只适用于视频流，bit_rate 或 duration 可能缺失、估算或属于全容器值；可追加 codec_name、sample_rate、channels、avg_frame_rate，并检查实际流而非假定只有一条。", size: 9.5pt)
  #raw("AVFormatContext *format = nullptr;\nif (avformat_open_input(&format, path, nullptr, nullptr) < 0) return reportOpenError();\nif (avformat_find_stream_info(format, nullptr) < 0) {\n    avformat_close_input(&format); return reportProbeError();\n}\nqInfo() << \"duration us\" << format->duration; // 单位 AV_TIME_BASE\nfor (unsigned i = 0; i < format->nb_streams; ++i) {\n    const AVStream *s = format->streams[i];\n    qInfo() << s->codecpar->codec_type << s->codecpar->width << s->codecpar->height\n            << s->avg_frame_rate.num << s->avg_frame_rate.den;\n}\navformat_close_input(&format); // duration/bitrate 可能缺失或估算", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("080  常见的硬件加速方案有哪些？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  常见硬件接口包括 NVIDIA NVENC/NVDEC、Intel Quick Sync、AMD AMF、Apple VideoToolbox、Linux VA-API 和 Windows DXVA/D3D11VA。它们是平台接口或厂商方案，具体可编解码标准、profile、位深、表面格式和并发数受芯片、驱动及 FFmpeg 构建影响；用 ffmpeg -encoders/-hwaccels 并实际打开设备验证。", size: 9.5pt)
  #raw("AVHWDeviceType type = AV_HWDEVICE_TYPE_NONE;\nwhile ((type = av_hwdevice_iterate_types(type)) != AV_HWDEVICE_TYPE_NONE) {\n    qInfo() << av_hwdevice_get_type_name(type); // 当前构建可识别的后端\n}\n// 再按 codec 的 AVCodecHWConfig 选择像素格式和设备类型\n// NVENC/VideoToolbox/VA-API 等能力由硬件、驱动、构建共同决定\n// 实际创建设备并解码验证；失败时回退软件路径", lang: "cpp", block: true)
]

#heading(level: 2, outlined: true)[#text("16.6 格式、性能与播放质量", size: 13pt, weight: "semibold", fill: rgb("#000000"))]
#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("081  常见的视频封装格式有哪些？MP4、FLV、MKV、AVI各有什么特点？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  MP4 通常兼容性好，适合点播与下载；Matroska/MKV 支持多轨、字幕和附件，封装灵活；FLV 曾广泛用于 RTMP 直播工作流；AVI 是较早容器，时序和新 codec 支持能力有限。容器本身不决定编码格式，也不保证所有播放器兼容其中的 codec、字幕类型和时间戳特性。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("082  常见的音频编码格式有哪些？AAC、MP3、Opus各有什么特点？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  MP3 兼容面很广，AAC 常见于移动设备和网络视频，Opus 面向低延迟交互并覆盖语音与音乐，三者都是有损编码。质量取决于编码器实现、码率、采样率、声道和输入内容，不存在各码率都成立的固定优劣排序；还要确认播放器和容器对目标 codec 的支持。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("083  直播推流时如何处理网络波动？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  推流端持续观测发送队列、丢包、RTT 和可用带宽，通过自适应码率/分辨率控制负载，并给队列设置上限以避免延迟堆积。可按场景用重传、FEC 或丢弃过期帧；关键帧间隔影响恢复等待。TCP 重传可能造成队头阻塞，UDP 则需应用协议处理丢失，策略要符合实时性目标。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("084  码率控制有哪些方式？CBR、VBR、ABR、CRF分别适用于什么场景？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  CBR 让目标码率较稳定，便于受限链路和广播预算，但瞬时质量会随内容变化；VBR 按复杂度分配码率，常见于质量优先文件。ABR 通常把长时间平均码率作为目标；CRF 是部分编码器的恒定质量控制，码率随内容变化且不等于固定大小保证。模式名称和参数含义因编码器而异。", size: 9.5pt)
  #raw("encoder->bit_rate = targetBps; // 目标平均速率\nencoder->rc_max_rate = peakBps; encoder->rc_buffer_size = bufferBits; // CBR/VBV 类约束\nav_opt_set(encoder->priv_data, \"crf\", \"23\", 0); // 某些编码器的质量模式\nif (avcodec_open2(encoder, codec, nullptr) < 0) return reportOptionError();\nwritePacketsUntilFlush(encoder);\n// CRF 不保证固定文件大小；选项名称/范围依具体编码器\n// 同一模式还受分辨率、场景复杂度和编码器实现影响", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("085  视频播放出现花屏的可能原因有哪些？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  花屏可来自源 packet 损坏/丢失、参考帧缺失、NAL 格式与解码器不匹配、硬解驱动问题，也可能是 plane 指针、stride、像素格式或色彩范围传错。先用 ffprobe/软件解码确认码流，再对比硬件解码输出；检查解码日志、关键帧恢复点和渲染上传尺寸，可区分传输、解码和显示阶段问题。", size: 9.5pt)
  #raw("if (frame->format == AV_PIX_FMT_NONE) reportMissingPixelFormat();\nfor (int plane = 0; plane < AV_NUM_DATA_POINTERS; ++plane) {\n    if (frame->data[plane]) qInfo() << plane << frame->linesize[plane];\n}\nif (frame->hw_frames_ctx) {\n    check(av_hwframe_transfer_data(cpuFrame, frame, 0)); // 对比软件可读画面\n}\n// 检查 packet 丢失、参考帧、plane/stride、range 与矩阵\n// 用关键帧恢复并比较软件/硬件解码区分输入与渲染问题", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("086  视频播放卡顿的可能原因有哪些？如何优化？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  先分别测网络等待/解复用、解码、滤镜、渲染和音频回调耗时，观察队列深度与 PTS；卡顿也可能是时钟漂移或丢帧策略不当。按瓶颈优化：启用兼容的硬解、异步 I/O、预读和有界队列，或降低输出尺寸/滤镜成本。增加缓冲可掩盖短抖动，却会增加延迟，不能替代性能修复。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("087  解释GOP（Group of Pictures）的概念，GOP大小对视频质量和码率有什么影响？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  GOP 是从随机访问图像到后续预测图像的编码结构，长度常用帧数或秒数表示；长 GOP 少用关键帧，往往提高压缩效率，但切入/seek 和丢包后恢复更慢。短 GOP 增加随机访问点并改善直播切片对齐，通常需要更多码率。开放/闭合 GOP、B 帧与 IDR 设置也会影响依赖和恢复边界。", size: 9.5pt)
  #raw("encoder->gop_size = fps * gopSeconds; // 约每 gopSeconds 秒一次随机访问点\nencoder->max_b_frames = 2; // 预测效率/重排延迟的取舍\nencoder->keyint_min = encoder->gop_size / 2; // 如编码器支持\ncheck(avcodec_open2(encoder, codec, nullptr));\nfor (AVFrame *f : frames) sendFrameAndDrainPackets(encoder, f);\n// 切片边界通常要对齐 IDR/随机访问帧\n// 长 GOP 省关键帧开销但切入/恢复更慢；最后 free codec context", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("088  解释熵编码的概念，CAVLC和CABAC有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  熵编码把量化后符号按统计概率映射为紧凑码字，本身无损；有损信息主要在量化阶段丢弃。H.264 CAVLC 依据邻近上下文做可变长编码，结构较简单；CABAC 使用上下文建模与算术编码，通常压缩更有效但解码计算较多。H.264 Baseline 不支持 CABAC，Main/High 可支持，设备 profile 必须匹配。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("089  运动估计（Motion Estimation）的原理是什么？常用的运动估计算法有哪些？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  编码器在参考帧的搜索区域中寻找与当前块最相似的候选位置，得到整数像素或亚像素运动矢量，再编码预测残差。全搜索结果通常好但计算量大；菱形、六边形、分层金字塔等搜索用较少候选加快估计，x264 等还会做亚像素细化、多参考帧搜索及率失真选择。估计最优不等于真实物体运动。", size: 9.5pt)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("090  量化（Quantization）在视频编码中的作用是什么？QP值如何影响视频质量？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  量化把变换系数按量化步长压缩，是视频有损信息损失的主要来源之一。H.264 的 QP 通常为 0–51，QP 越高步长越大，细节保留减少；降低 QP 通常提高质量并增加码率。QP 每升 6，量化步长约翻倍，但码率变化受内容和模式控制，不保证正好减半；固定 QP 下场景码率也会变。", size: 9.5pt)
  #raw("// 仅当所选编码器支持其私有参数时设置\nif (av_opt_set(encoder->priv_data, \"qp\", \"23\", 0) < 0)\n    reportUnsupportedQpMode();\ncheck(avcodec_open2(encoder, codec, nullptr));\nsendFrameAndDrainPackets(encoder, frame);\n// H.264 QP 越高量化步长越大；较低通常保留细节也增码率\n// QP 每升 6 步长约翻倍，但码率不保证减半\n// CRF 与固定 QP 是不同控制模式", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("091  零拷贝技术在音视频处理中如何应用？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  零拷贝常通过引用计数 AVBufferRef、共享 DMA-BUF/硬件帧、内存映射或设备间表面传递，减少 CPU 将整帧 memcpy 到新缓冲区的次数。只有解码器、滤镜和编码器支持兼容格式及同一设备上下文时才能贯通；同步栅栏、所有权和生命周期仍需管理，格式转换或跨设备读回常会重新引入拷贝。", size: 9.5pt)
  #raw("AVFrame *handoff = av_frame_clone(decoded); // 共享 AVBufferRef 帧数据\nif (!handoff) return reportOutOfMemory();\nqueue.push(handoff); // 队列持有引用，消费者处理完 av_frame_free\nif (needsWrite) check(av_frame_make_writable(handoff)); // 共享时可能复制\n// 硬件帧贯通还要求相同设备/格式并处理同步 fence\n// 跨设备读回或像素格式转换会重新产生拷贝", lang: "cpp", block: true)
]

#block(width: 100%, breakable: false)[
  #heading(level: 2, outlined: false)[#text("092  音频采样格式有哪些？Planar和Packed格式有什么区别？", size: 10.5pt, weight: "semibold", fill: rgb("#1E3A50"))]
  #text("答案  采样格式规定单个样本是有符号整数还是浮点以及位宽，如 S16、S32、FLT；声道布局另行描述包含哪些声道。Packed 把同一采样时刻的各声道交错存放，Planar 则每个声道有独立 plane，例如立体声 FLTP 有两路 float 数组。读取 AVFrame 时应检查 format、ch_layout、nb_samples 和 linesize，不能按 channels 简单推断指针布局。", size: 9.5pt)
  #raw("const auto format = static_cast<AVSampleFormat>(frame->format);\nqInfo() << av_get_sample_fmt_name(format) << frame->nb_samples << frame->sample_rate;\nif (av_sample_fmt_is_planar(format)) {\n    for (int ch = 0; ch < frame->ch_layout.nb_channels; ++ch)\n        consumeChannel(frame->extended_data[ch], frame->nb_samples); // 每声道 plane\n} else {\n    consumePacked(frame->data[0], frame->nb_samples * frame->ch_layout.nb_channels);\n}\n// 读取前检查 ch_layout/linesize；planar 和 packed 指针布局不同\n", lang: "cpp", block: true)
]

#heading(level: 1, outlined: true)[#text("参考文献", size: 15pt, weight: "bold", fill: rgb("#000000"))]
#text("S1 仅用于面经考点调研；S2–S22 为语言标准、官方手册、RFC、原始论文与 API 文档，用于核对答案中的规则、行为和适用边界。", size: 9.5pt)
- [S1] 面经与题目主题调研（仅用于发现考点）：#link("https://cppguide.cn/pages/cppinterviewmostaskedquestions01/")[C++ 面试问题集锦] · #link("https://kavinchan13.github.io/tech-notes/interview/cpp_interview_cards.html")[C++ 面试题卡片集]
- [S2] C++ Working Draft：语言规则、库设施与并发规范：#link("https://eel.is/c++draft/")[在线工作草案]
- [S3] GCC 优化选项：LTO 与 profile guided optimization：#link("https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html")[GCC 手册]
- [S4] Itanium C++ ABI：对象布局、调用接口和运行时约定示例：#link("https://itanium-cxx-abi.github.io/cxx-abi/abi.html")[ABI 规范]
- [S5] Linux man-pages：fork、listen、epoll、io_uring 与 socket 选项：#link("https://man7.org/linux/man-pages/man2/fork.2.html")[fork(2)] · #link("https://man7.org/linux/man-pages/man2/listen.2.html")[listen(2)] · #link("https://man7.org/linux/man-pages/man7/epoll.7.html")[epoll(7)] · #link("https://man7.org/linux/man-pages/man7/io_uring.7.html")[io_uring(7)] · #link("https://man7.org/linux/man-pages/man7/socket.7.html")[socket(7)]
- [S6] Boost.Asio：Proactor 异步操作模型：#link("https://www.boost.org/latest/doc/html/boost_asio/overview/core/async.html")[设计说明]
- [S7] IETF TCP 与 HTTP 规范：#link("https://www.rfc-editor.org/rfc/rfc9293.html")[TCP RFC 9293] · #link("https://www.rfc-editor.org/rfc/rfc9113.html")[HTTP/2 RFC 9113] · #link("https://www.rfc-editor.org/rfc/rfc9114.html")[HTTP/3 RFC 9114] · #link("https://www.rfc-editor.org/rfc/rfc9110.html")[HTTP 语义 RFC 9110] · #link("https://www.rfc-editor.org/rfc/rfc8446.html")[TLS 1.3 RFC 8446]
- [S8] IETF DNS 概念与设施 RFC 1034：#link("https://www.rfc-editor.org/rfc/rfc1034.html")[RFC 1034]
- [S9] MySQL Reference Manual：InnoDB redo、MVCC、锁和 binlog：#link("https://dev.mysql.com/doc/refman/8.4/en/innodb-redo-log.html")[Redo log] · #link("https://dev.mysql.com/doc/refman/8.4/en/innodb-multi-versioning.html")[MVCC] · #link("https://dev.mysql.com/doc/refman/8.4/en/innodb-locking.html")[锁] · #link("https://dev.mysql.com/doc/refman/8.4/en/binary-log.html")[Binlog 与两阶段提交] · #link("https://dev.mysql.com/doc/refman/8.4/en/innodb-undo-logs.html")[undo] · #link("https://dev.mysql.com/doc/refman/8.4/en/innodb-index-types.html")[索引] · #link("https://dev.mysql.com/doc/refman/8.4/en/innodb-transaction-isolation-levels.html")[隔离级别]
- [S10] Redis 文档：热 Key、大 Key 与分布式锁：#link("https://redis.io/docs/latest/operate/rs/monitoring/observability/")[热点与大 Key 观测] · #link("https://redis.io/docs/latest/develop/clients/patterns/distributed-locks/")[分布式锁和 fencing token]
- [S11] Raft 原始论文：In Search of an Understandable Consensus Algorithm：#link("https://raft.github.io/raft.pdf")[扩展版论文]
- [S12] Apache Kafka 设计：幂等生产者与事务语义：#link("https://kafka.apache.org/41/design/design/")[设计文档]
- [S13] Debezium 文档：Outbox Event Router：#link("https://debezium.io/documentation/reference/stable/transformations/outbox-event-router.html")[Transactional Outbox]
- [S14] OpenCV 4.10 文档：cv::Mat 与相机标定：#link("https://docs.opencv.org/4.10.0/d3/d63/classcv_1_1Mat.html")[cv::Mat] · #link("https://docs.opencv.org/4.10.0/d4/d94/tutorial_camera_calibration.html")[相机标定]
- [S15] Microsoft Azure Architecture Center：Circuit Breaker Pattern：#link("https://learn.microsoft.com/en-us/azure/architecture/patterns/circuit-breaker")[熔断器模式]
- [S16] Qt 6 官方文档：QObject 生命周期、线程与信号槽：#link("https://doc.qt.io/qt-6/qobject.html")[QObject] · #link("https://doc.qt.io/qt-6/threads-qobject.html")[Threads and QObjects] · #link("https://doc.qt.io/qt-6/qthread.html")[QThread] · #link("https://doc.qt.io/qt-6/signalsandslots.html")[Signals & Slots]
- [S17] Qt 6 官方文档：容器、模型/视图与数据库：#link("https://doc.qt.io/qt-6/containers.html")[容器] · #link("https://doc.qt.io/qt-6/qabstractitemmodel.html")[QAbstractItemModel] · #link("https://doc.qt.io/qt-6/qsqlquery.html")[QSqlQuery] · #link("https://doc.qt.io/qt-6/qsqldatabase.html")[QSqlDatabase]
- [S18] Qt 6 官方文档：QML、插件与版本迁移：#link("https://doc.qt.io/qt-6/qtqml-cppintegration-contextproperties.html")[QML/C++ 集成] · #link("https://doc.qt.io/qt-6/qpluginloader.html")[QPluginLoader] · #link("https://doc.qt.io/qt-6/qtcore-changes-qt6.html")[Qt 6 迁移]
- [S19] Qt 6 官方文档：图表与多媒体：#link("https://doc.qt.io/qt-6/qtcharts-overview.html")[Qt Charts] · #link("https://doc.qt.io/qt-6.12/qtgraphs-index.html")[Qt Graphs] · #link("https://doc.qt.io/qt-6/qtmultimedia-index.html")[Qt Multimedia]
- [S20] FFmpeg 官方文档：命令行、编解码 API、滤镜与拼接：#link("https://ffmpeg.org/documentation.html")[文档入口] · #link("https://ffmpeg.org/doxygen/trunk/group__lavc__decoding.html")[解码 API] · #link("https://ffmpeg.org/ffmpeg-filters.html")[滤镜手册] · #link("https://ffmpeg.org/faq.html")[FAQ]
- [S21] OpenCV 4.x 官方文档：图像处理、矩阵与标定：#link("https://docs.opencv.org/4.x/")[文档入口] · #link("https://docs.opencv.org/4.x/d3/d63/classcv_1_1Mat.html")[cv::Mat] · #link("https://docs.opencv.org/4.x/d4/d94/tutorial_camera_calibration.html")[相机标定]
- [S22] ROS 2 QoS 官方设计文档：#link("https://design.ros2.org/articles/qos.html")[QoS 策略] · #link("https://design.ros2.org/articles/qos_deadline_liveliness_lifespan.html")[Deadline、Liveliness 与 Lifespan]
