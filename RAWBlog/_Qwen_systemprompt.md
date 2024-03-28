# 1 
在使用OpenAI的API时，如果你想要像之前定义的模型那样添加一个`system`参数，你需要考虑API实际支持的参数和功能。根据OpenAI提供的官方文档，`system`参数不是标准的API参数，这意味着你不能直接像`model`或`messages`那样传递`system`参数。

然而，如果`system`参数是你自定义模型中特有的一部分，而这个自定义模型是通过OpenAI平台提供服务的，那么在API层面可能不直接支持修改这个`system`参数。通常，这类特定参数的设置是在模型训练或部署阶段决定的。

但你可以通过以下方法尝试间接地传递`system`信息：

1. **在消息内容中添加`system`信息**：如果`system`信息对模型生成的回答有影响，并且模型已经被训练为识别并基于特定提示或上下文信息作出响应，你可以尝试将这个`system`信息作为聊天历史的一部分来发送。例如，你可以在发送的第一条消息中包含`system`信息：

    ```python
    response = openai.ChatCompletion.create(
        model="Qwen",
        messages=[
            {"role": "system", "content": "作为实体关系提取模型，提取语句中的实体与关系，以三元组形式回复"},
            {"role": "user", "content": "你好"}
        ],
        stream=False,
        stop=["Observation:"]  # 自定义的停止词
    )
    ```

2. **通过自定义设置或API调用传递**：如果OpenAI提供了针对特定模型设置参数的接口（比如在模型部署或调用时的配置接口），则可以通过这些接口来设定`system`信息。这通常需要查阅特定模型或服务的文档。

3. **联系OpenAI支持**：如果以上方法都不适用，或者你需要更直接的方式来传递这类信息，最好的方式是联系OpenAI的技术支持，了解是否有针对你使用的模型提供定制化传参的可能性。

请注意，具体实施取决于你使用的OpenAI模型或服务的具体特性，以及OpenAI平台当前的功能限制。
  

```
# 使用深拷贝来复制传入的消息列表，这样在修改messages时不会影响原始列表。
messages = copy.deepcopy(messages)

# 检查消息列表的第一条消息是否为系统角色的消息。
if messages[0].role == 'system':
    # 如果是，将这条系统消息从列表中移除，并且去除其内容的首尾换行符，然后将其内容赋给system变量。
    system = messages.pop(0).content.lstrip('\n').rstrip()
else:
    # 如果列表中的第一条消息不是系统角色的消息，则将默认字符串'You are a helpful assistant.'赋给system变量。
    # 这个默认值通常用作模型的默认上下文或提示。
    system = 'You are a helpful assistant.'
```


在这段代码中，`system`变量被用来存储系统级的提示或信息，这通常是针对后续处理或模型预测的背景信息。如果消息列表的第一条是系统消息（即角色为`'system'`），这条消息将被设置为`system`的内容，并从消息列表中移除，以便后续处理中只包含用户和助手的对话。如果没有系统级消息，则使用默认的助手描述。


# 2 
在您之前提供的代码框架中，如果想要以API的方式调用模型并传递`system`参数，您需要按照以下步骤进行修改和扩展：

1. **扩展请求模型**：首先，您需要在`ChatCompletionRequest`类中添加一个新字段来接收`system`参数。这允许API的用户在发起请求时指定`system`参数。

    ```python
    class ChatCompletionRequest(BaseModel):
        ...
        system: Optional[str] = None  # 添加system参数，可选，类型为字符串
        ...
    ```

2. **修改API端点**：然后，在处理聊天完成请求的API端点`create_chat_completion`中，您需要修改函数体以接收并处理新的`system`参数。当调用模型进行聊天时，将这个参数传递给模型。

    ```python
    @app.post('/v1/chat/completions', response_model=ChatCompletionResponse)
    async def create_chat_completion(request: ChatCompletionRequest):
        ...
        # 在调用模型前获取system参数
        system = request.system if request.system is not None else "默认的系统提示文本"
        ...
        # 在调用模型时传递system参数
        response, _ = model.chat(
            tokenizer,
            query,
            history=history,
            system=system,  # 将系统提示传递给模型
            ...
        )
        ...
    ```

3. **更新API文档和测试**：确保更新相关的API文档，以反映这一新功能。您可以使用FastAPI的自动生成文档功能来帮助完成这项工作。然后，进行API调用测试以确保新的`system`参数能够正确传递并由模型处理。

通过这些更改，您就可以在API调用中包含`system`参数了。这样，当外部用户通过API发送聊天完成请求时，他们就可以指定一个`system`参数，该参数随后会传递给模型进行相应的聊天生成处理。