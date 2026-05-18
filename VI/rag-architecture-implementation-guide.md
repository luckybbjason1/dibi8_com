---
title: 'Hướng Dẫn Triển Khai Kiến Trúc RAG 2025: Xây Dựng Hệ Thống Production'
description: 'Hướng dẫn triển khai kiến trúc RAG production 2025: từ Naive RAG đến Agentic RAG. So sánh framework, chiến lược chunking và đánh giá hiệu suất.'
date: 2026-05-18 00:00:00+08:00
lastmod: 2026-05-18 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: 'dibi8'
last_maintained: '2026-05-18'
featureImage: ''
draft: false
aliases:
- /posts/rag-architecture-implementation-guide/
---

{</* resource-info */>}

Retrieval-Augmented Generation (RAG) đã trở thành kiến trúc tiêu chuẩn để xây dựng các ứng dụng AI có khả năng truy xuất thông tin chính xác từ dữ liệu riêng. Khác với việc fine-tune model trên toàn bộ tập dữ liệu, RAG cho phép LLM truy cập thông tin cập nhật mà không cần huấn luyện lại. Bài viết này hướng dẫn từng bước xây dựng hệ thống RAG production-ready, từ kiến trúc cơ bản đến các kỹ thuật nâng cao nhất năm 2025.

## RAG Là Gì? Hiểu Về Retrieval-Augmented Generation

### Luồng Hoạt Động Cơ Bản Củaa RAG

Kiến trúc RAG gồm hai giai đoạn chính:

1. **Indexing**: Dữ liệu được chia nhỏ, chuyển thành vector embedding, và lưu vào vector database
2. **Retrieval + Generation**: Khi ngườii dùng đặt câu hỏi, hệ thống tìm các đoạn văn bản liên quan nhất từ vector DB, sau đó đưa vào LLM để tạo câu trả lờii có căn cứ

Luồng này giúp LLM trả lờii dựa trên thông tin thực tế thay vì "halucinate" (bịa ra câu trả lờii).

### Tại Sao RAG Quan Trọng: Giảm Halucination

Các LLM như GPT-4 có kiến thức đến thờii điểm huấn luyện và không thể truy cập dữ liệu nội bộ của bạn. Khi được hỏi về tài liệu công ty, model sẽ bịa ra câu trả lờii nghe có vẻ hợp lý nhưng hoàn toàn sai lệch — hiện tượng được gọi là hallucination. RAG giải quyết vấn đề này bằng cách cung cấp ngữ cảnh thực tế trong prompt [^1^](https://python.langchain.com).

### RAG So Với Fine-Tuning: Nên Dùng Cái Nào?

| Tiêu Chí | RAG | Fine-Tuning |
|----------|-----|-------------|
| **Dữ liệu cần thiết** | Ít (chỉ cần vectorize) | Nhiều (cần training data) |
| **Thờii gian triển khai** | Vài giờ | Vài ngày đến vài tuần |
| **Chi phí cập nhật** | Thấp (thêm documents) | Cao (huấn luyện lại) |
| **Kiến thức mới** | Tự động cập nhật | Cần retrain |
| **Phong cách trả lờii** | Giữ nguyên model | Thay đổi phong cách |
| **Tài nguyên** | Vector DB + LLM API | GPU training |

Trong thực tế, 80% các ứng dụng bắt đầu với RAG vì triển khai nhanh và linh hoạt. Fine-tuning chỉ được áp dụng khi cần thay đổi hành vi hoặc phong cách của model.

## Các Thành Phần Kiến Trúc RAG

### Pipeline Ingestion Tài Liệu

Dữ liệu thô cần qua nhiều bước xử lý trước khi có thể truy vấn:

```
[Documents] → [Parser] → [Splitter] → [Embedder] → [Vector DB]
   PDF       Extract     Chunking     Embedding     Storage
   Word      Text        Splitting    Model         Index
   HTML
```

### Chiến Lược Chia Văn Bản (Chunking)

Chunking là một trong những yếu tố quan trọng nhất ảnh hưởng đến chất lượng RAG. Các phương pháp phổ biến:

| Phương Pháp | Mô Tả | Ưu Điểm | Nhược Điểm |
|-------------|-------|---------|------------|
| **Fixed size** | Chia theo số token cố định | Đơn giản, nhanh | Cắt ngang câu, ngữ cảnh |
| **Recursive** | Chia theo hierarchy (paragraph → sentence) | Giữ cấu trúc văn bản | Phức tạp hơn |
| **Semantic** | Chia theo ý nghĩa (dùng model) | Chunks có ý nghĩa hoàn chỉnh | Chậm, tốn tài nguyên |
| **Agentic** | Dùng LLM quyết định điểm chia | Tối ưu nhất | Tốn chi phí API |

Kích thước chunk tối ưu thường từ 256 đến 1024 tokens, tùy thuộc vào độ dài trung bình của đoạn thông tin trong dữ liệu.

### Lựa Chọn Model Embedding

Model embedding chuyển văn bản thành vector. Các lựa chọn phổ biến [^2^](https://huggingface.co/spaces/mteb/leaderboard):

- **OpenAI text-embedding-3-large**: 3072 chiều, hiệu suất cao, tính phí
- **BGE-M3 (BAAI)**: Mã nguồn mở, hỗ trợ đa ngôn ngữ, miễn phí
- **E5-Mistral**: Hiệu suất top-tier, miễn phí qua Hugging Face
- **Voyage AI**: Chuyên embedding cho RAG, chất lượng rất cao

### Cơ Chế Truy Xuất (Retrieval)

Có hai loại retrieval chính:

- **Dense retrieval**: Dùng embedding vector để tìm đoạn văn bản tương tự về ngữ nghĩa
- **Sparse retrieval**: Dùng keyword matching (BM25) để tìm chính xác từ khóa

### Re-ranking Và Context Compression

Sau khi truy xuất kết quả, re-ranking model đánh giá lại độ liên quan để sắp xếp tốt hơn:

- **Cohere Rerank**: API đơn giản, hiệu quả cao
- **BGE Reranker**: Mã nguồn mở, chạy local
- **Cross-encoder**: Tối ưu nhất nhưng chậm hơn

Context compression loại bỏ thông tin không liên quan từ retrieved chunks trước khi đưa vào LLM, giúp tiết kiệm tokens và cải thiện chất lượng.

## RAG Đơn Giản (Naive RAG): Nền Tảng

### Triển Khai Cơ Bản Với LangChain

```python
from langchain.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.vectorstores import Chroma
from langchain.embeddings import OpenAIEmbeddings
from langchain.chains import RetrievalQA
from langchain.llms import OpenAI

# 1. Load và split documents
loader = PyPDFLoader("document.pdf")
docs = loader.load()
splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
chunks = splitter.split_documents(docs)

# 2. Tạo vector store
vectorstore = Chroma.from_documents(chunks, OpenAIEmbeddings())

# 3. Tạo QA chain
qa = RetrievalQA.from_chain_type(
    llm=OpenAI(),
    retriever=vectorstore.as_retriever(search_kwargs={"k": 5})
)

# 4. Query
result = qa.run("Nội dung chính của tài liệu là gì?")
```

### Triển Khai Cơ Bản Với LlamaIndex

```python
from llama_index import VectorStoreIndex, SimpleDirectoryReader
from llama_index.embeddings.openai import OpenAIEmbedding

documents = SimpleDirectoryReader("./data").load_data()
index = VectorStoreIndex.from_documents(documents)
query_engine = index.as_query_engine()
response = query_engine.query("Câu hỏi của bạn")
```

### Hạn Chế Củaa Naive RAG

Naive RAG hoạt động tốt cho prototype nhưng gặp nhiều vấn đề ở quy mô production:

- **Chunk boundary problem**: Thông tin bị cắt ngang qua chunk boundary
- **Query-document mismatch**: Cách diễn đạt trong query khác với trong document
- **Lost in the middle**: LLM tập trung vào thông tin ở đầu và cuối context
- **No source verification**: Không kiểm tra tính chính xác của retrieved information

## Kỹ Thuật RAG Nâng Cao

### Query Rewriting Và Expansion

Thay vì trực tiếp dùng query của ngườii dùng để tìm kiếm, hệ thống có thể:

- **Rewrite query**: Dùng LLM viết lại query rõ ràng hơn
- **HyDE (Hypothetical Document Embedding)**: Tạo ra một "tài liệu lý tưởng" cho truy vấn rồi dùng embedding của tài liệu đó để tìm kiếm
- **Query expansion**: Thêm các từ đồng nghĩa hoặc cách diễn đạt khác

### Hybrid Search (Dense + Sparse)

Kết hợp cả vector search và keyword search để tận dụng ưu điểm của cả hai:

```python
# Kết hợp BM25 và vector search
from langchain.retrievers import BM25Retriever, EnsembleRetriever

bm25_retriever = BM25Retriever.from_documents(docs)
vector_retriever = vectorstore.as_retriever()

ensemble = EnsembleRetriever(
    retrievers=[bm25_retriever, vector_retriever],
    weights=[0.5, 0.5]
)
```

### Contextual Compression Và Re-ranking

```python
from langchain.retrievers.contextual_compression import ContextualCompressionRetriever
from langchain_cohere import CohereRerank

compressor = CohereRerank()
compression_retriever = ContextualCompressionRetriever(
    base_compressor=compressor,
    base_retriever=retriever
)
```

### Multi-Query Retrieval

Tạo nhiều biến thể của câu hỏi gốc và truy xuất cho mỗi biến thể, sau đó gộp kết quả:

```python
from langchain.retrievers.multi_query import MultiQueryRetriever

multi_retriever = MultiQueryRetriever.from_llm(
    retriever=base_retriever,
    llm=ChatOpenAI()
)
```

### Parent Document Retrieval

Lưu cả chunk nhỏ (để tìm kiếm) và document cha (để đưa vào LLM). Khi một chunk nhỏ được match, toàn bộ document cha được đưa vào context. Điều này giúp LLM có đầy đủ ngữ cảnh [^3^](https://docs.llamaindex.ai).

### Sentence-Window Retrieval

Tương tự parent document retrieval nhưng ở cấp độ câu: lưu embedding cho từng câu riêng lẻ, nhưng khi match, lấy cả cửa sổ xung quanh (2-3 câu trước và sau).

## Modular RAG Và Agentic RAG

### Self-RAG: Truy Xuất Có Phản Xạ

Self-RAG (bài báo tháng 10/2023) dạy LLM tự quyết định khi nào cần truy xuất thông tin thêm. Model sẽ:

1. Tạo câu trả lờii sơ bộ
2. Đánh giá xem câu trả lờii đã đủ chính xác chưa
3. Nếu chưa, truy xuất thêm thông tin
4. Lặp lại cho đến khi hài lòng

### Corrective RAG (CRAG)

CRAG thêm bước kiểm tra chất lượng retrieved documents:

- Nếu documents kém chất lượng → tìm kiếm thêm trên web
- Nếu documents tốt → sử dụng để trả lờii
- Nếu trung bình → kết hợp cả hai nguồn

### Agentic RAG Với Tool Use

Agentic RAG sử dụng LLM như một agent có khả năng:

- Quyết định cần truy xuất từ nguồn nào
- Gọi các công cụ khác nhau (calculator, search engine)
- Thực hiện nhiều bước suy luận phức tạp
- Tự đánh giá và sửa lỗi

### Multi-Modal RAG (Text + Images)

RAG không giới hạn ở văn bản. Với multi-modal embedding models (như CLIP), bạn có thể:

- Truy xuất hình ảnh liên quan đến câu hỏi văn bản
- Hỏi về nội dung hình ảnh trong tài liệu
- Kết hợp thông tin từ cả text và image trong cùng một response

## Xây Dựng Hệ Thống RAG Production Từng Bước

### Bước 1: Thu Thập Và Tiền Xử Lý Dữ Liệu

- Xác định nguồn dữ liệu (PDF, Word, web pages, database)
- Xử lý dữ liệu không cấu trúc (OCR cho scanned PDF, HTML parsing)
- Làm sạch dữ liệu (loại bỏ header/footer, chuẩn hóa format)

### Bước 2: Chọn Model Embedding

Chọn embedding model dựa trên:

| Use Case | Model Đề Xuất | Chi Phí |
|----------|--------------|---------|
| Tiếng Anh, ngân sách cao | OpenAI text-embedding-3-large | $0.13/1M tokens |
| Đa ngôn ngữ, miễn phí | BGE-M3 | Miễn phí |
| Chất lượng cao nhất | Voyage-3 | $0.10/1M tokens |
| Local deployment | E5-Mistral | Miễn phí (cần GPU) |

### Bước 3: Tối Ưu Chiến Lược Chunking

Thử nghiệm nhiều kích thước chunk và đánh giá:

```
Kích thước chunk: 256, 512, 1024, 2048
Overlap: 10%, 20%, 50%
Phương pháp: fixed, recursive, semantic
```

Tổng cộng có thể có 36+ tổ hợp. Dùng RAGAS framework để tự động đánh giá và chọn tốt nhất.

### Bước 4: Thiết Lập Vector Database

Xem phần so sánh vector database để chọn giải pháp phù hợp. Đối với RAG production, khuyến nghị:

- **Pinecone**: Cloud-managed, dễ scaling
- **Milvus**: Hiệu suất cao, self-hosted
- **pgvector**: Nếu đã dùng PostgreSQL

### Bước 5: Tuning Và Đánh Giá Retrieval

Các tham số cần tune:

- **Top-k**: Số documents truy xuất (thường 3-10)
- **Similarity threshold**: Ngưỡng tối thiểu để coi là liên quan
- **Reranking**: Có nên dùng re-ranker không?

### Bước 6: Chọn LLM Và Prompt Engineering

| LLM | Ưu Điểm | Chi Phí |
|-----|---------|---------|
| GPT-4o | Chất lượng cao nhất | $5/1M input tokens |
| Claude 3.5 Sonnet | Context window dài, reasoning tốt | $3/1M input tokens |
| Llama 3.1 70B | Miễn phí, tự chủ | Chi phí GPU |
| Qwen2.5 72B | Tiếng Việt tốt | Miễn phí |

Prompt engineering cho RAG thường bao gồm system prompt hướng dẫn model chỉ dùng thông tin được cung cấp và trả lờii "I don't know" nếu không tìm thấy thông tin.

### Bước 7: Testing Và Triển Khai End-to-End

- Unit test từng thành phần riêng lẻ
- Integration test toàn pipeline
- Load test với số lượng request dự kiến
- Monitoring và alerting trong production

## Framework Đánh Giá RAG

### Các Chỉ Số Đánh Giá Retrieval

- **Recall@k**: Tỷ lệ relevant documents nằm trong top-k kết quả
- **MRR (Mean Reciprocal Rank)**: Thứ hạng trung bình của kết quả đầu tiên đúng
- **NDCG**: Đo lường chất lượng ranking tổng thể

### Các Chỉ Số Đánh Giá Generation

- **Faithfulness**: Câu trả lờii có dựa trên ngữ cảnh được cung cấp không
- **Answer relevance**: Câu trả lờii có liên quan đến câu hỏi không
- **Context precision**: Ngữ cảnh có chứa thông tin cần thiết không

### RAGAS Framework

RAGAS là framework tự động hóa việc đánh giá RAG [^4^](https://docs.ragas.io):

```python
from ragas import evaluate
from ragas.metrics import faithfulness, answer_relevancy, context_precision

result = evaluate(
    dataset=eval_dataset,
    metrics=[faithfulness, answer_relevancy, context_precision]
)
```

### Đánh Giá Bởi Ngườii Và Giám Sát Liên Tục

Ngoài metrics tự động, cần có đánh giá thủ công trên mẫu đại diện. Trong production, thu thập feedback từ ngườii dùng (thumbs up/down) để cải thiện hệ thống liên tục.

## Tối Ưu Hiệu Suất RAG

### Tối Ưu Kích Thước Chunk

Thử nghiệm A/B với các kích thước chunk khác nhau. Kết quả thường thấy:

- **Chunks nhỏ (256-512 tokens)**: Phù hợp cho factual QA, precise retrieval
- **Chunks lớn (1024-2048 tokens)**: Phù hợp cho summarization, complex reasoning

### Tuning Top-K Và Ngưỡng Similarity

- Top-k quá thấp: có thể bỏ sót thông tin
- Top-k quá cao: nhiễu, tốn tokens
- Ngưỡng similarity quá thấp: trả về kết quả không liên quan
- Ngưỡng similarity quá cao: không trả về đủ kết quả

### Chiến Lược Caching

- **Embedding cache**: Cache embedding cho documents phổ biến
- **Query cache**: Cache kết quả cho câu hỏi thường gặp
- **LLM response cache**: Cache câu trả lờii cho câu hỏi giống nhau

### Tối Ưu Độ Trễ

| Bước | Thờii Gian Tiêu Chuẩn | Cách Tối Ưu |
|------|----------------------|-------------|
| Embedding query | 50-200ms | Cache, batching |
| Vector search | 10-100ms | Index tuning, sharding |
| Re-ranking | 100-500ms | Skip nếu không cần |
| LLM generation | 1-10s | Streaming, model nhỏ hơn |

### Tối Ưu Chi Phí

- Dùng model embedding miễn phí (BGE-M3) cho 90% use case
- Cache embedding cho documents tĩnh
- Chọn LLM phù hợp: không cần GPT-4 cho mọi câu hỏi
- Tối ưu prompt: càng ngắn càng rẻ

## RAG Với Các Thành Phần Mã Nguồn Mở

### Sử Dụng Ollama Cho Embedding Và LLM

```python
from langchain_community.embeddings import OllamaEmbeddings
from langchain_community.llms import Ollama

embeddings = OllamaEmbeddings(model="nomic-embed-text")
llm = Ollama(model="llama3.1:8b")
```

### BGE Embeddings (Mã Nguồn Mở)

BGE-M3 là một trong những model embedding mã nguồn mở tốt nhất, hỗ trợ hơn 100 ngôn ngữ:

```python
from sentence_transformers import SentenceTransformer
model = SentenceTransformer('BAAI/bge-m3')
embeddings = model.encode(sentences)
```

### Triển Khai RAG Hoàn Toàn Private

Với các tổ chức có yêu cầu bảo mật dữ liệu nghiêm ngặt (y tế, tài chính, chính phủ), RAG có thể triển khai hoàn toàn on-premises:

- **Embedding model**: BGE-M3 hoặc E5 chạy local
- **LLM**: Llama 3.1, Qwen2.5 chạy qua vLLM hoặc Ollama
- **Vector database**: Milvus hoặc pgvector self-hosted
- **Tất cả dữ liệu**: Không rờii khỏi mạng nội bộ

## So Sánh Các Framework RAG

### LangChain RAG

LangChain [^1^](https://github.com/langchain-ai/langchain) là framework phổ biến nhất với ecosystem rộng nhất:

- **Ưu điểm**: Nhiều integration nhất, community lớn, tài liệu phong phú
- **Nhược điểm**: API thay đổi thường xuyên, learning curve dốc

### LlamaIndex RAG

LlamaIndex [^3^](https://docs.llamaindex.ai) tập trung vào data ingestion và retrieval:

- **Ưu điểm**: Tốt nhất cho complex data, agents, structured data
- **Nhược điểm**: Ít integration hơn LangChain

### Haystack Cho Enterprise RAG

Haystack (deepset) là framework RAG thiết kế cho enterprise:

- **Ưu điểm**: Pipeline rõ ràng, dễ debug, production-ready
- **Nhược điểm**: Community nhỏ hơn

### RAGFlow Cho Hiểu Sâu Tài Liệu

RAGFlow là giải pháp RAG end-to-end mới nhất, tập trung vào "deep document understanding":

- **Ưu điểm**: Template-based RAG, UI trực quan, xử lý tài liệu phức tạp tốt
- **Nhược điểm**: Còn mới, ecosystem chưa lớn

| Framework | Điểm Mạnh | Phù Hợp Cho |
|-----------|-----------|-------------|
| LangChain | Ecosystem rộng nhất | Prototyping, nhiều integration |
| LlamaIndex | Data ingestion tốt nhất | Complex documents, agents |
| Haystack | Pipeline rõ ràng | Enterprise, production |
| RAGFlow | Deep understanding | Document-heavy use cases |

## Các Sai Lầm Thường Gặp Và Giải Pháp

### Xử Lý Các Trường Hợp Đặc Biệt

- **Câu hỏi không liên quan đến dữ liệu**: Thiết lập ngưỡng similarity, trả về "I don't know"
- **Thông tin mâu thuẫn trong documents**: Thêm bước conflict resolution
- **Documents dài và phức tạp**: Dùng hierarchical RAG

### Xử Lý Bộ Sưu Tập Tài Liệu Lớn

Với hàng triệu documents:

- Dùng vector database phân tán (Milvus cluster)
- Implement sharding theo domain hoặc thờii gian
- Pre-filter trước khi vector search (metadata filtering)
- Dùng approximate nearest neighbor thay vì exact search

### Hỗ Trợ Tài Liệu Đa Ngôn Ngữ

- Dùng embedding model đa ngôn ngữ (BGE-M3, multilingual-e5)
- Phát hiện ngôn ngữ và route đến pipeline phù hợp
- Dịch câu hỏi sang ngôn ngữ của documents nếu cần

### Cập Nhật Knowledge Base

- **Incremental indexing**: Chỉ index documents mới hoặc thay đổi
- **Versioning**: Giữ nhiều phiên bản của cùng một document
- **Soft delete**: Đánh dấu xóa thay vì xóa vĩnh viễn
- **Scheduled sync**: Tự động đồng bộ theo lịch

## Kết Luận Và Tương Lai Củaa RAG

Kiến trúc RAG đã phát triển từ pipeline đơn giản (load → split → embed → retrieve → generate) thành các hệ thống phức tạp với nhiều lớp tối ưu. Năm 2025, xu hướng chính là Agentic RAG — nơi LLM không chỉ trả lờii câu hỏi mà còn tự quyết định cần truy xuất thông tin từ đâu, khi nào, và như thế nào.

Để xây dựng hệ thống RAG production thành công, hãy bắt đầu với Naive RAG để nhanh chóng validate ý tưởng, sau đó từ từ thêm các kỹ thuật nâng cao dựa trên kết quả đánh giá. Không có giải pháp one-size-fits-all — mỗi use case đều cần tuning riêng.

## Câu Hỏi Thường Gặp

### Sự Khác Biệt Giữa RAG Và Fine-Tuning Là Gì?

RAG truy xuất thông tin từ dữ liệu bên ngoài và đưa vào prompt trong quá trình inference — không thay đổi trọng số model. Fine-tuning cập nhật trọng số model bằng cách huấn luyện trên dữ liệu mới. RAG phù hợp cho dữ liệu thay đổi thường xuyên, fine-tuning phù hợp cho thay đổi hành vi model.

### Model Embedding Nào Tốt Nhất Cho RAG?

OpenAI text-embedding-3-large có hiệu suất cao nhất trên benchmark MTEB. Tuy nhiên, BGE-M3 là lựa chọn miễn phí tốt nhất cho đa ngôn ngữ, và E5-Mistral cho tiếng Anh. Nếu triển khai local, BGE-M3 hoặc nomic-embed-text là lựa chọn phù hợp.

### Làm Thế Nào Để Đánh Giá Hiệu Suất Hệ Thống RAG?

Sử dụng framework RAGAS để đánh giá tự động các metrics: faithfulness (độ trung thực), answer relevancy (độ liên quan câu trả lờii), context precision (độ chính xác ngữ cảnh). Kết hợp với đánh giá thủ công trên 50-100 câu hỏi đại diện.

### RAG Có Hoạt Động Với LLM Local Không?

Hoàn toàn có. Bạn có thể dùng Ollama để chạy Llama 3.1, Qwen2.5 hoặc Mistral local kết hợp với vector database local (Chroma, Milvus) và embedding model local (BGE-M3) để xây dựng hệ thống RAG hoàn toàn private không cần internet.

### Agentic RAG Khác Gì So Với RAG Thông Thường?

Agentic RAG sử dụng LLM như một "agent" thông minh có khả năng tự quyết định: khi nào cần truy xuất, truy xuất từ đâu, có cần dùng công cụ bổ sung không, và khi nào đã đủ thông tin để trả lờii. Thay vì pipeline cố định, Agentic RAG có luồng động thích ứng với từng câu hỏi.

---

## Hạ Tầng Đề Xuất

Để chạy các công cụ trên 24/7 ổn định, lựa chọn hạ tầng rất quan trọng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 tín dụng miễn phí 60 ngày, 14+ region toàn cầu.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp. dibi8.com cũng host ở đây.
- **[Hostinger](https://www.hostinger.com/vn?REFERRALCODE=22RPIAOJIYJN)** — VPS giá tốt cho thị trường Việt Nam.

*Đây là affiliate link, không tăng chi phí của bạn nhưng giúp dibi8.com duy trì hoạt động.*

