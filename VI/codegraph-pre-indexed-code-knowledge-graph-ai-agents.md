---
title: "CodeGraph: Xây dựng Đồ thị Kiến thức Mã nguồn từ Toàn bộ Mã nguồn"
slug: "codegraph-pre-indexed-code-knowledge-graph-ai-agents"
category: "dev-utils"
publish_date: "2026-06-10"
author: "DIBI8"
tags: ["kotlin", "graph", "code-analysis", "devtools", "knowledge-graph"]
featureImage: "https://avatars.githubusercontent.com/u/11434"
---

# CodeGraph: Xây dựng Đồ thị Kiến thức Mã nguồn từ Toàn bộ Mã nguồn

## Giới thiệu

Mọi dự án phần mềm đều phát triển vượt quá khả năng nhận thức của con người. Thành viên mới trong nhóm dành hàng tuần chỉ để học cách một hàm sống ở đâu và nó kết nối với phần còn lại của hệ thống như thế nào. CodeGraph là một công cụ mã nguồn mở biến toàn bộ mã nguồn của bạn thành một đồ thị kiến thức có thể điều hướng, cho phép bạn hiểu mối quan hệ giữa các lớp, hàm, giao diện và gói ngay lập tức. Được xây dựng bằng Kotlin, CodeGraph cung cấp một CLI mạnh mẽ và một API lập trình cho các nhà phát triển cần hiểu sâu về mã nguồn.

## CodeGraph là gì?

CodeGraph là một thư viện và công cụ CLI gốc Kotlin phân tích mã nguồn của bạn và xây dựng một biểu diễn đồ thị toàn diện. Hãy tưởng tượng nó như một cơ sở dữ liệu đồ thị phổ quát cho mã của bạn: mọi nút là một phần tử chương trình (lớp, hàm, gói, giao diện), và mỗi cạnh đại diện cho một mối quan hệ (kế thừa, thực hiện, gọi, phụ thuộc). Với cấu trúc đồ thị này, bạn có thể trả lời các câu hỏi như "lớp nào thực hiện giao diện này?" và "các phụ thuộc truyền dẫn của gói này là gì?" trong vài mili giây.

Công cụ hỗ trợ Kotlin, Java và có thể được mở rộng cho các ngôn ngữ JVM khác. Nó sử dụng cơ chế phân tích của chính trình biên dịch Kotlin, vì vậy nó hiểu toàn bộ ngữ cảnh ngữ nghĩa của mã của bạn, không chỉ các mẫu văn bản bề mặt.

Để tìm hiểu thêm về các công cụ phân tích mã, xem [dibi8-internal-link](https://dibi8.com).

## Tính năng chính

CodeGraph gói gọn một lượng chức năng đáng kinh ngạc trong một gói nhỏ gọn:

- **Phân tích mã tự động**: Xây dựng đồ thị phụ thuộc đầy đủ từ mã nguồn
- **API truy vấn**: Truy vấn lập trình để tìm nút, duyệt qua các mối quan hệ và lọc kết quả
- **Công cụ CLI**: Tạo đồ thị bằng một lệnh và truy vấn tương tác từ terminal
- **Khả năng xuất**: Xuất đồ thị dưới dạng JSON, DOT (Graphviz) hoặc GraphML
- **Cập nhật tăng dần**: Chỉ tái xây dựng các phần đã thay đổi để phân tích nhanh
- **Tích hợp IDE**: Có thể dùng như thư viện để hỗ trợ plugin IDE
- **Truy vấn tùy chỉnh**: Viết truy vấn của riêng bạn bằng ngôn ngữ truy vấn đồ thị tích hợp

## Cài đặt

Cài đặt CodeGraph rất đơn giản. Cách phổ biến nhất là qua plugin Gradle hoặc phụ thuộc Maven. Bạn cũng có thể tải trực tiếp JAR CLI.

### Cài đặt qua Gradle

Thêm CodeGraph như một phụ thuộc trong `build.gradle.kts` của bạn:

```kotlin
plugins {
    id("org.jetbrains.kotlin.jvm") version "1.9.22"
}

dependencies {
    implementation("io.codegraph:codegraph-core:1.2.0")
    implementation("io.codegraph:codegraph-cli:1.2.0")
}
```

### Cài đặt qua Maven

```xml
<dependency>
    <groupId>io.codegraph</groupId>
    <artifactId>codegraph-core</artifactId>
    <version>1.2.0</version>
</dependency>
```

### Cài đặt CLI

Tải JAR CLI mới nhất và chạy trực tiếp:

```bash
curl -L -o codegraph-cli.jar https://repo.maven.apache.org/maven2/io/codegraph/codegraph-cli/1.2.0/codegraph-cli-1.2.0.jar
java -jar codegraph-cli.jar --version
```

hoặc cài đặt qua Homebrew trên macOS:

```bash
brew tap codegraph/tap
brew install codegraph
```

## Xây dựng đồ thị đầu tiên của bạn

Sau khi CodeGraph được cài đặt, tạo một đồ thị kiến thức từ mã nguồn của bạn chỉ cần một lệnh:

```bash
codegraph scan \
  --source-dir ./src/main \
  --output-dir ./codegraph-output \
  --format json
```

Lệnh này quét tất cả các tệp nguồn Kotlin và Java dưới `./src/main`, xây dựng đồ thị phụ thuộc và xuất nó sang JSON trong `./codegraph-output`. Bạn có thể thay `json` bằng `dot` cho định dạng Graphviz hoặc `graphml` cho định dạng tương thích với các công cụ cơ sở dữ liệu đồ thị.

Sau khi tạo, kiểm tra kết quả đầu ra:

```bash
codegraph inspect \
  --input ./codegraph-output/graph.json \
  --query "classes package=com.example.service"
```

## Sử dụng API lập trình

Để tích hợp sâu hơn, CodeGraph cung cấp một API lập trình phong phú. Dưới đây là cách tải đồ thị, truy vấn và trích xuất mối quan hệ một cách lập trình:

```kotlin
import io.codegraph.*
import io.codegraph.query.*

fun main() {
    // Tải đồ thị hiện có
    val graph = GraphLoader.loadFromJson("codegraph-output/graph.json")

    // Tìm tất cả các lớp kế thừa một lớp cơ sở cụ thể
    val subclasses = graph.query {
        where { type == NodeType.CLASS }
        where { name == "com.example.service.UserService" }
        followEdge(EdgeType.EXTENDS)
        select()
    }

    // Tìm tất cả các trình gọi của một phương thức cụ thể
    val callers = graph.query {
        where { name == "UserService.login" }
        traceBackward(EdgeType.CALLS)
        where { type == NodeType.FUNCTION }
        select()
    }

    // Tính toán các phụ thuộc truyền dẫn cho một gói
    val dependencies = graph.query {
        where { package == "com.example.api" }
        followEdges(EdgeType.DEPENDS_ON)
        depth = 3
        selectUnique()
    }

    println("Lớp con: ${subclasses.count()}")
    println("Trình gọi: ${callers.count()}")
    println("Phụ thuộc truyền dẫn: ${dependencies.count()}")
}
```

## Truy vấn đồ thị bằng ngôn ngữ truy vấn tích hợp

CodeGraph bao gồm một ngôn ngữ truy vấn khai báo mạnh mẽ. Dưới đây là một số mẫu phổ biến:

### Tìm tất cả các lớp trong một gói

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "classes package=com.example.api"
```

### Tìm các hàm gọi một phương thức cụ thể

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "callers of UserService.login"
```

### Theo dõi chuỗi gọi cho một hàm

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "call chain of UserController.processRequest" \
  --depth 5
```

### Tìm các hàm bị cô lập

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "functions with zero callers"
```

### Phát hiện phụ thuộc vòng lặp

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "circular dependencies among packages"
```

## Trường hợp sử dụng

CodeGraph phục vụ nhiều kịch bản phát triển đa dạng. Đây là những trường hợp có tác động nhất:

### Đào tạo nhân viên mới

Thành viên mới có thể truy vấn đồ thị để hiểu cấu trúc mã nguồn mà không cần đọc mọi tệp. Một truy vấn đơn giản như `classes package=com.example` trả về danh sách sạch tất cả các lớp được tổ chức theo gói, cung cấp bản đồ tư duy tức thì về kiến trúc.

### An toàn khi tái cấu trúc

Trước khi tái cấu trúc một lớp hoặc hàm, nhà phát triển có thể theo dõi tất cả các trình phụ thuộc và trình gọi để hiểu phạm vi ảnh hưởng của các thay đổi. Điều này ngăn ngừa sự ngạc nhiên kinh điển "tôi chỉ thay đổi một phương thức" nơi một thay đổi nhỏ phá vỡ hàng chục tệp không liên quan.

### Phát hiện vi phạm kiến trúc

CodeGraph có thể tự động phát hiện vi phạm kiến trúc. Ví dụ, bạn có thể truy vấn bất kỳ phụ thuộc nào từ lớp UI đến lớp dữ liệu bỏ qua lớp dịch vụ:

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "classes package=ui" \
  --follow "DEPENDS_ON" \
  --filter "classes package=repo" \
  --violation "should go through service layer"
```

### Nhận diện nợ kỹ thuật

Các hàm có quá nhiều cạnh đầu vào hoặc các hàm không có trình gọi nào có thể cho thấy gánh năng bảo trì. CodeGraph đánh dấu những vấn đề này bằng các truy vấn:

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "functions with callers > 20"
```

### Phân tích bề mặt API

Đối với các API công khai, CodeGraph giúp xác định bề mặt công khai thực sự của thư viện bằng cách theo dõi các lớp và phương thức nào được hiển thị cho người tiêu dùng bên ngoài thay vì chi tiết triển khai nội bộ.

Để tìm hiểu thêm về các công cụ hệ sinh thái Kotlin, xem [dibi8-internal-link](https://dibi8.com).

## So sánh: CodeGraph vs. Các công cụ thay thế

| Tính năng | CodeGraph | Sourcetrail | IDE Index | jOOQ Codegen | ArchUnit |
|-----------|-----------|-------------|-----------|-------------|----------|
| Trực quan hóa đồ thị | Có | Có | Không | Không | Không |
| Ngôn ngữ truy vấn | Built-in DSL | Lọc thủ công | Thanh tìm kiếm | N/A | Java DSL |
| Cập nhật tăng dần | Có | Không | Có | N/A | N/A |
| Hỗ trợ CLI | Full CLI | Chỉ GUI | Chỉ IDE | N/A | Chỉ test |
| Định dạng xuất | JSON, DOT, GraphML | Chỉ DOT | N/A | N/A | N/A |
| Hỗ trợ ngôn ngữ | Kotlin, Java | Đa ngôn ngữ | Đa ngôn ngữ | Java | Java |
| Khả năng mở rộng | Plugin API | Hạn chế | IDE plugin | N/A | Java tests |
| API lập trình | Kotlin API | Không | N/A | API | Test API |
| Quy mô cộng đồng | Đang phát triển | Trưởng thành | Rất lớn | Lớn | Lớn |
| Trạng thái bảo trì | Hoạt động | Không hoạt động | Hoạt động | Hoạt động | Hoạt động |

## Ví dụ thực tế: Xây dựng máy chủ GraphQL

Giả sử bạn đang xây dựng máy chủ GraphQL bằng Ktor. CodeGraph giúp bạn trực quan hóa mối quan hệ giữa các mô hình dữ liệu, kiểu GraphQL và bộ giải trình:

```kotlin
import io.codegraph.*

fun analyzeGraphQLServer() {
    val graph = GraphLoader.loadFromJson("graphql-project/codegraph-output/graph.json")

    // Tìm tất cả các lớp mô hình dữ liệu
    val models = graph.query {
        where { package.startsWith("com.myapp.model") }
        where { type == NodeType.CLASS }
        select()
    }

    // Tìm tất cả bộ giải GraphQL
    val resolvers = graph.query {
        where { package.startsWith("com.myapp.graphql") }
        where { type == NodeType.FUNCTION }
        select()
    }

    // Tìm ánh xạ giữa các mô hình và bộ giải
    val mappings = graph.query {
        from(models)
        followEdge(EdgeType.CALLS)
        whereIn(resolvers)
        select()
    }

    println("Mô hình dữ liệu: ${models.count()}")
    println("Bộ giải: ${resolvers.count()}")
    println("Ánh xạ mô hình-bộ giải: ${mappings.count()}")
}
```

Phân tích này tiết lộ các khoảng trống trong phạm vi phủ bộ giải của bạn và giúp đảm bảo mọi mô hình dữ liệu đều có bộ giải GraphQL tương ứng.

## So sánh: CodeGraph vs. Kiểm tra mã truyền thống

| Khía cạnh | CodeGraph | Kiểm tra mã thủ công | Tìm kiếm mã (grep/ripgrep) |
|-----------|-----------|---------------------|---------------------------|
| Hiểu mối quan hệ | Đồ thị đầy đủ, phụ thuộc truyền dẫn | Một phần, phụ thuộc kinh nghiệm | Dựa trên văn bản, không có ngữ nghĩa |
| Thời gian tìm kết nối | Giây | Phút đến giờ | Giây nhưng không đầy đủ |
| Độ chính xác | 100% (ngữ nghĩa) | Có lỗi con người | Chỉ cú pháp, bỏ sót ngữ nghĩa |
| Phạm vi | Toàn bộ mã nguồn | Hạn chế ở tệp đã duyệt | Toàn bộ mã nguồn nhưng ngây thơ |
| Trực quan hóa | Đồ thị tương tác | Không có | Không có |
| Phân tích tăng dần | Chỉ thay đổi | Cần duyệt toàn bộ | Cần quét lại toàn bộ |
| Tự động hóa | Hoàn toàn tự động | Quy trình thủ công | Một phần tự động |
| Đường cong học tập | Trung bình (Kotlin) | Cao (kiến thức mã nguồn) | Thấp |

## Tích hợp với quy trình CI/CD

CodeGraph tích hợp liền mạch vào quy trình CI/CD để tự động thực thi các quy tắc kiến trúc:

```yaml
# .github/workflows/codegraph.yml
name: Phân tích CodeGraph
on:
  pull_request:
    branches: [main]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Thiết lập JDK
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'
      - name: Tạo Code Graph
        run: |
          ./gradlew codegraphGenerate
      - name: Kiểm tra quy tắc kiến trúc
        run: |
          ./gradlew codegraphCheck --rules=arch-rules.json
      - name: Xuất báo cáo đồ thị
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: codegraph-report
          path: build/codegraph/
```

## Hạn chế

Mặc dù CodeGraph rất mạnh mẽ, nhưng nó có một số hạn chế quan trọng:

1. **Chỉ ngôn ngữ JVM**: Hiện tại hỗ trợ Kotlin và Java. Không hỗ trợ JavaScript, Python hoặc các ngôn ngữ không phải JVM khác.
2. **Không có phân tích runtime**: CodeGraph chỉ phân tích cấu trúc tĩnh compile-time. Gọidispatch động, gọi dựa trên phản xạ và mã được tạo tại runtime không thể hiện hữu.
3. **Phủ thư viện bên thứ ba**: Các phụ thuộc từ JAR bên ngoài có thể không được phân tích đầy đủ trừ khi nguồn có sẵn.
4. **Sử dụng bộ nhớ**: Các mã nguồn lớn (500K+ dòng) yêu cầu không gian heap đáng kể để xây dựng đồ thị. Khuyến nghị ít nhất 4GB RAM.
5. **Phụ thuộc build**: CodeGraph cần biên dịch mã của bạn như một phần của phân tích, điều này thêm thời gian build cho các bản quét tăng dần.
6. **Không hỗ trợ truy vấn ngôn ngữ tự nhiên**: Truy vấn sử dụng cú pháp khai báo, không phải ngôn ngữ tự nhiên. Một lớp ngôn ngữ tự nhiên có thể được thêm vào trên cùng nhưng không được bao gồm.
7. **Phân tích single-threaded**: Xây dựng đồ thị là single-threaded, có thể chậm đối với các dự án rất lớn.

## Câu hỏi thường gặp (FAQ)

### Q1: CodeGraph hỗ trợ những ngôn ngữ nào?

CodeGraph hiện hỗ trợ Kotlin và Java. Nó sử dụng các API nội bộ của trình biên dịch Kotlin cho phân tích, có nghĩa là nó có sự hiểu biết ngữ nghĩa sâu sắc về mã Kotlin. Hỗ trợ cho các ngôn ngữ JVM khác như Scala và Groovy được lên kế hoạch cho các bản phát hành tương lai.

### Q2: CodeGraph có thể phân tích các dự án Gradle đa mô-đun không?

Có. CodeGraph xử lý native các dự án Gradle và Maven đa mô-đun. Khi bạn chạy `codegraph scan` ở gốc dự án, nó tự động phát hiện tất cả các mô-đun và các phụ thuộc giữa chúng. Cờ `--multi-module` kích hoạt phân tích giữa các mô-đun bổ sung:

```bash
codegraph scan --source-dir . --multi-module
```

### Q3: CodeGraph có thể xử lý mã nguồn lớn đến mức nào?

CodeGraph đã được kiểm tra với các mã nguồn lên đến 2 triệu dòng mã. Hiệu suất mở rộng xấp xỉ tuyến tính với kích thước mã. Đối với các mã nguồn rất lớn (1M+ dòng), tăng kích thước heap JVM xuống 8GB hoặc hơn:

```bash
java -Xmx8g -jar codegraph-cli.jar scan --source-dir ./src
```

### Q4: Tôi có thể sử dụng CodeGraph với các dự án không phải Kotlin không?

Nếu dự án của bạn biên dịch trên JVM, bạn có thể sử dụng CodeGraph. Nó hoạt động với bất kỳ dự án Java hoặc Kotlin nào bất kể khung, thư viện hoặc công cụ xây dựng được sử dụng. Các ngôn ngữ JVM thuần túy như Scala và Clojure hoạt động tốt. Đối với các dự án không phải JVM, bạn cần một công cụ khác.

### Q5: CodeGraph có xử lý mã được tạo động không?

CodeGraph phân tích mã nguồn được biên dịch tĩnh. Nếu dự án của bạn sử dụng tạo mã (ví dụ: Kotlin Poet, jOOQ codegen, Protobuf), bạn nên đảm bảo mã được tạo được bao gồm trong mục tiêu quét. Thêm các thư mục nguồn được tạo vào đường dẫn quét:

```bash
codegraph scan \
  --source-dir ./src/main \
  --source-dir ./build/generated
```

### Q6: CodeGraph có thể được sử dụng cho các chỉ số chất lượng mã không?

Có. CodeGraph có thể tính toán nhiều chỉ số chất lượng mã từ cấu trúc đồ thị: độ phức tạp cyclomatic khi kết hợp với phân tích AST, chỉ số coupling, điểm cohesion và độ sâu phụ thuộc. Sử dụng lệnh con `codegraph metrics`:

```bash
codegraph metrics --input ./codegraph-output/graph.json --output ./report.json
```

### Q7: CodeGraph khác với các công cụ phân tích mã tích hợp sẵn trong IDE như thế nào?

Các công cụ IDE cung cấp phân tích theo thời gian thực cho tệp đang mở. CodeGraph phân tích toàn bộ mã nguồn và cung cấp một đồ thị vĩnh viễn có thể được truy vấn, xuất và tích hợp vào các quy trình tự động hóa. Sử dụng công cụ IDE cho điều hướng hàng ngày và CodeGraph cho phân tích kiến trúc sâu.

## Nguồn

1. Kho lưu trữ chính thức CodeGraph: https://github.com/kotlin-io/codegraph
2. Tài liệu CodeGraph: https://codegraph.io/docs
3. Nguyên lý biên dịch Kotlin: https://github.com/JetBrains/kotlin/tree/master/compiler
4. Thực tiễn tốt cơ sở dữ liệu đồ thị: https://neo4j.com/docs/
5. Phân tích kiến trúc phần mềm với công cụ phân tích tĩnh: https://www.seas.upenn.edu/~sergey/papers/

## Kêu gọi hành động

Sẵn sàng biến mã nguồn của bạn thành một đồ thị kiến thức có thể điều hướng? Hãy thử CodeGraph ngay hôm nay và không bao giờ phải vật lộn để hiểu kiến trúc dự án của bạn nữa.

Để biết thêm thông tin, tham gia cộng đồng Telegram của chúng tôi: https://t.me/DIBI8_Group/18

**Công cụ được đề xuất:**

- Binance: Bắt đầu giao dịch với Binance. Đăng ký tại: https://www.bsmkweb.cc/register?ref=DIBI8
- OKX Exchange: Giao dịch với OKX. Đăng ký tại: https://www.promoohubly.com/join/12190433
- WebShare: Duyệt web ẩn danh với WebShare. Bắt đầu tại: https://www.webshare.io/?referral_code=oa14d5f0wx4f
- DigitalOcean: Triển khai dự án của bạn trên DigitalOcean. Đăng ký tại: https://m.do.co/c/eca87ac14ee0
- HTStack: Quản lý cơ sở hạ tầng đám mây của bạn. Tham gia tại: https://my.htstack.com/aff.php?aff=27187

---

DIBI8 là cổng vào để khám phá các công cụ mã nguồn mở tốt nhất, đổi mới AI và tài nguyên nhà phát triển. Đăng ký kênh Telegram của chúng tôi để nhận cập nhật hàng ngày về các dự án có tác động nhất trong công nghệ.
