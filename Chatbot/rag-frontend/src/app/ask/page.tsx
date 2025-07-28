"use client";

import { useState, useTransition, useRef, useEffect, JSX } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Loader2, Search, Filter, Send, Bot, User, ChevronDown } from "lucide-react";
import clsx from "clsx";

// -------- Types
interface Filters {
  warehouse_id?: number | null;
  material_id?: number | null;
  material_type?: string | null;
  material_group?: string | null;
  personnel_id?: string | null;
  date_from?: string | null;
  date_to?: string | null;
  aggregate: string;
  top_k?: number | null;
}

interface AskResponse {
  answer: string;
  filters: Filters | null;
  source_count: number;
  aggregations: any[] | null;
  source_sample: Record<string, any>[];
}

interface Message {
  id: string;
  type: 'user' | 'assistant';
  content: string;
  data?: AskResponse;
  timestamp: Date;
}

// -------- Helper Components
const Chip = ({ label, value }: { label: string; value: string | number | null | undefined }) => {
  if (value === null || value === undefined || value === "") return null;
  return (
    <span className="inline-flex items-center px-3 py-1 rounded-full bg-blue-50 border border-blue-200 text-blue-800 text-xs mr-2 mb-1">
      <Filter className="w-3 h-3 mr-1" />
      <span className="font-semibold">{label}:</span>
      <span className="ml-1 font-medium">{value.toString()}</span>
    </span>
  );
};

const ThinkingAnimation = () => (
  <div className="flex items-center space-x-1 text-gray-500">
    <div className="flex space-x-1">
      <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{ animationDelay: '0ms' }}></div>
      <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{ animationDelay: '150ms' }}></div>
      <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{ animationDelay: '300ms' }}></div>
    </div>
    <span className="text-sm ml-2">Düşünüyor...</span>
  </div>
);

const MarkdownRenderer = ({ content }: { content: string }) => {
  const lines = content.split('\n');
  const elements: JSX.Element[] = [];
  let currentList: JSX.Element[] = [];
  let listType: 'ordered' | 'unordered' | null = null;

  const flushList = () => {
    if (currentList.length > 0) {
      if (listType === 'ordered') {
        elements.push(<ol key={`list-${elements.length}`} className="list-decimal list-inside ml-4 mb-3 space-y-1">{currentList}</ol>);
      } else {
        elements.push(<ul key={`list-${elements.length}`} className="list-disc list-inside ml-4 mb-3 space-y-1">{currentList}</ul>);
      }
      currentList = [];
      listType = null;
    }
  };

  lines.forEach((line, index) => {
    // Headers
    if (line.startsWith('### ')) {
      flushList();
      elements.push(<h3 key={index} className="text-base font-bold mt-3 mb-2 text-gray-900">{line.replace('### ', '')}</h3>);
      return;
    }
    if (line.startsWith('## ')) {
      flushList();
      elements.push(<h2 key={index} className="text-lg font-bold mt-3 mb-2 text-gray-900">{line.replace('## ', '')}</h2>);
      return;
    }
    if (line.startsWith('# ')) {
      flushList();
      elements.push(<h1 key={index} className="text-xl font-bold mt-3 mb-2 text-gray-900">{line.replace('# ', '')}</h1>);
      return;
    }
    
    // Ordered lists
    if (line.match(/^\d+\.\s/)) {
      if (listType !== 'ordered') {
        flushList();
        listType = 'ordered';
      }
      const text = line.replace(/^\d+\.\s/, '').replace(/\*\*(.*?)\*\*/g, '<strong class="font-bold">$1</strong>');
      currentList.push(<li key={`${index}-li`} className="text-gray-900 text-sm" dangerouslySetInnerHTML={{ __html: text }} />);
      return;
    }
    
    // Unordered lists
    if (line.startsWith('- ')) {
      if (listType !== 'unordered') {
        flushList();
        listType = 'unordered';
      }
      const text = line.replace(/^- /, '').replace(/\*\*(.*?)\*\*/g, '<strong class="font-bold">$1</strong>');
      currentList.push(<li key={`${index}-li`} className="text-gray-900 text-sm" dangerouslySetInnerHTML={{ __html: text }} />);
      return;
    }
    
    // Regular content
    flushList();
    
    // Empty lines
    if (line.trim() === '') {
      elements.push(<br key={index} />);
      return;
    }
    
    // Bold text
    const processedLine = line.replace(/\*\*(.*?)\*\*/g, '<strong class="font-bold text-gray-900">$1</strong>');
    elements.push(<p key={index} className="mb-2 text-gray-900 text-sm leading-relaxed" dangerouslySetInnerHTML={{ __html: processedLine }} />);
  });

  // Flush any remaining list
  flushList();

  return <div className="prose prose-sm max-w-none">{elements}</div>;
};

const MessageBubble = ({ message }: { message: Message }) => {
  const isUser = message.type === 'user';
  
  return (
    <div className={clsx("flex mb-6", isUser ? "justify-end" : "justify-start")}>
      <div className={clsx("flex", isUser ? "flex-row-reverse max-w-[70%]" : "flex-row max-w-[85%]")}>
        {/* Avatar */}
        <div className={clsx("flex-shrink-0", isUser ? "ml-3" : "mr-3")}>
          <div className={clsx(
            "w-10 h-10 rounded-full flex items-center justify-center",
            isUser ? "bg-gray-900 text-white" : "bg-gray-100 text-gray-700"
          )}>
            {isUser ? <User className="w-5 h-5" /> : <Bot className="w-5 h-5" />}
          </div>
        </div>
        
        {/* Message Content */}
        <div className={clsx(
          "rounded-2xl px-4 py-3 shadow-sm",
          isUser 
            ? "bg-gray-900 text-white rounded-br-md" 
            : "bg-white border border-gray-200 rounded-bl-md"
        )}>
          {isUser ? (
            <p className="text-sm text-white">{message.content}</p>
          ) : (
            <div className="space-y-3">
              <div className="text-gray-900">
                <MarkdownRenderer content={message.content} />
              </div>
              
              {/* Data sections */}
              {message.data && (
                <div className="space-y-3 pt-3 border-t border-gray-100">
                  {/* Filters */}
                  {message.data.filters && Object.values(message.data.filters).some(v => v !== null && v !== undefined && v !== "") && (
                    <div>
                      <h4 className="text-sm font-semibold text-gray-800 mb-2">Uygulanan Filtreler</h4>
                      <div className="flex flex-wrap">
                        {Object.entries(message.data.filters).map(([k, v]) => (
                          <Chip key={k} label={k} value={v as any} />
                        ))}
                      </div>
                    </div>
                  )}

                  {/* Aggregations */}
                  {message.data.aggregations && message.data.aggregations.length > 0 && (
                    <div>
                      <h4 className="text-sm font-semibold text-gray-800 mb-2">Toplam Veriler</h4>
                      <div className="bg-gray-50 rounded-lg p-3">
                        {message.data.aggregations.map((agg, i) => (
                          <div key={i} className="text-sm">
                            {Object.entries(agg).map(([k, v]) => (
                              <span key={k} className="mr-4 inline-block">
                                <span className="font-medium text-gray-800">{k}:</span> <span className="text-gray-700">{v as any}</span>
                              </span>
                            ))}
                          </div>
                        ))}
                      </div>
                    </div>
                  )}

                  {/* Source Sample Table */}
                  {message.data.source_sample && message.data.source_sample.length > 0 && (
                    <div>
                      <h4 className="text-sm font-semibold text-gray-800 mb-2">Örnek Veriler ({message.data.source_count} kayıt bulundu)</h4>
                      <div className="overflow-x-auto border border-gray-200 rounded-lg">
                        <table className="min-w-full text-xs">
                          <thead className="bg-gray-50">
                            <tr>
                              {Object.keys(message.data.source_sample[0]).map((col) => (
                                <th key={col} className="px-2 py-2 text-left font-semibold text-gray-800 text-[10px] uppercase tracking-wide">
                                  {col.replace(/_/g, ' ')}
                                </th>
                              ))}
                            </tr>
                          </thead>
                          <tbody>
                            {message.data.source_sample.map((row, idx) => (
                              <tr key={idx} className={clsx(idx % 2 === 0 ? "bg-white" : "bg-gray-50")}>
                                {Object.values(row).map((val, i) => (
                                  <td key={i} className="px-2 py-2 text-gray-800 text-xs font-medium">
                                    {val as any}
                                  </td>
                                ))}
                              </tr>
                            ))}
                          </tbody>
                        </table>
                      </div>
                    </div>
                  )}
                </div>
              )}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

// -------- Main Component
export default function ModernChatAssistant() {
  const [messages, setMessages] = useState<Message[]>([]);
  const [question, setQuestion] = useState("");
  const [isPending, startTransition] = useTransition();
  const [error, setError] = useState<string | null>(null);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages, isPending]);

  const handleSubmit = () => {
    if (!question.trim() || isPending) return;
    
    const userMessage: Message = {
      id: Date.now().toString(),
      type: 'user',
      content: question,
      timestamp: new Date()
    };
    
    setMessages(prev => [...prev, userMessage]);
    setError(null);
    setQuestion("");
    
    startTransition(async () => {
      try {
        const res = await fetch("http://localhost:3000/ask", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ question }),
        });
        
        if (!res.ok) throw new Error("API error");
        
        const data: AskResponse = await res.json();
        
        const assistantMessage: Message = {
          id: (Date.now() + 1).toString(),
          type: 'assistant',
          content: data.answer,
          data: data,
          timestamp: new Date()
        };
        
        setMessages(prev => [...prev, assistantMessage]);
      } catch (err) {
        setError("Bir hata oluştu. Lütfen tekrar deneyin.");
        const errorMessage: Message = {
          id: (Date.now() + 1).toString(),
          type: 'assistant',
          content: "Üzgünüm, şu anda bir teknik sorun yaşıyorum. Lütfen daha sonra tekrar deneyin.",
          timestamp: new Date()
        };
        setMessages(prev => [...prev, errorMessage]);
      }
    });
  };

  return (
    <div className="h-screen bg-gray-50 flex flex-col">
      {/* Header */}
      <div className="bg-white border-b border-gray-200 px-6 py-4">
        <div className="max-w-4xl mx-auto flex items-center">
          <div className="flex items-center space-x-3">
            <div className="w-10 h-10 bg-gray-900 rounded-full flex items-center justify-center">
              <Bot className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="text-xl font-semibold text-gray-900">BMC Envanter Asistanı</h1>
              <p className="text-sm text-gray-500">Size yardımcı olmak için buradayım</p>
            </div>
          </div>
        </div>
      </div>

      {/* Messages */}
      <div className="flex-1 overflow-y-auto">
        <div className="max-w-4xl mx-auto px-6 py-6">
          {messages.length === 0 ? (
            <div className="text-center py-12">
              <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <Search className="w-8 h-8 text-gray-400" />
              </div>
              <h2 className="text-xl font-medium text-gray-900 mb-2">Merhaba! 👋</h2>
              <p className="text-gray-600 max-w-md mx-auto">
                Envanter ile ilgili herhangi bir sorunuz var mı? Size yardımcı olmak için buradayım.
              </p>
            </div>
          ) : (
            <div className="space-y-1">
              {messages.map((message) => (
                <MessageBubble key={message.id} message={message} />
              ))}
              
              {/* Thinking animation */}
              {isPending && (
                <div className="flex justify-start mb-6">
                  <div className="flex mr-3">
                    <div className="w-10 h-10 bg-gray-100 rounded-full flex items-center justify-center">
                      <Bot className="w-5 h-5 text-gray-700" />
                    </div>
                  </div>
                  <div className="bg-white border border-gray-200 rounded-2xl rounded-bl-md px-4 py-3 shadow-sm">
                    <ThinkingAnimation />
                  </div>
                </div>
              )}
            </div>
          )}
          <div ref={messagesEndRef} />
        </div>
      </div>

      {/* Input */}
      <div className="bg-white border-t border-gray-200 px-6 py-4">
        <div className="max-w-4xl mx-auto">
          {error && (
            <div className="mb-3 p-3 bg-red-50 border border-red-200 rounded-lg">
              <p className="text-sm text-red-600">{error}</p>
            </div>
          )}
          <div className="flex space-x-3">
            <div className="flex-1 relative">
              <Input
                placeholder="Envanter hakkında bir soru sorun..."
                value={question}
                onChange={(e) => setQuestion(e.target.value)}
                onKeyDown={(e) => e.key === "Enter" && !e.shiftKey && handleSubmit()}
                disabled={isPending}
                className="pr-12 rounded-full border-gray-300 focus:border-gray-900 focus:ring-gray-900"
              />
            </div>
            <Button 
              onClick={handleSubmit} 
              disabled={isPending || !question.trim()}
              className="rounded-full bg-gray-900 hover:bg-gray-800 text-white px-6"
            >
              {isPending ? (
                <Loader2 className="w-4 h-4 animate-spin" />
              ) : (
                <Send className="w-4 h-4" />
              )}
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}