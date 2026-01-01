# OAuth2.0 接入

~~**注意 OAuth 是直接访问的 auth 服务，没有通过 gateway**~~ 现在可以直接通过 gateway 访问

1. App 后端判断没有登录，返回 401 给前端
2. App 前端重定向 Pig 统一登录中心

```
http://127.0.0.1:9999/auth/oauth2/authorize?response_type=code&client_id=app&scope=server&redirect_uri=http://localhost:4040/sso1/login

```
注意：
 - client_id 需要添加：http://localhost:8888/#/admin/client/index
 - client_id 需要添加忽略配置里面：security.ignore-clients
 - redirect_uri 需要和配置的相同：http://localhost:8888/#/admin/client/index
 - 访问认证 URL 后的行为是跟请求头相关的，请求头中没有 `X-Requested-With` 不等于 `XMLHttpRequest` 并且 `Accept` in [`text/html`,`application/xhtml+xml`,`text/plain`,`image/*`]，才返回 302，否则返回 401

3. 用户在 Pig 统一登录中心登录
4. 登录成功后 Pig 重定向到 http://localhost:4040/sso1/login?code=6UJdQTzNTAzm8X8KTtiQ8YYoVqvUumYxuicehJ6t2vMXg7QieuSaK-CUKNoCWCgvGQUp1iDYPX7otl9q3ZG12Ppe8NMYDPaPpQDhl9_v-u2-HSwSVefnQG07TbefK5DT

5. App 前端通过 code 请求 App 后端
6. App 后端调用 Pig API 生成 token 返回给前端
   
```http
POST http://127.0.0.1:3000/oauth2/token
Authorization: Basic YXBwOmFwcA==
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code
&code=6UJdQTzNTAzm8X8KTtiQ8YYoVqvUumYxuicehJ6t2vMXg7QieuSaK-CUKNoCWCgvGQUp1iDYPX7otl9q3ZG12Ppe8NMYDPaPpQDhl9_v-u2-HSwSVefnQG07TbefK5DT
&redirect_uri=http://localhost:4040/sso1/login
&scope=server
```

注意：
    - Authorization 携带的是 base64 编码后的 `${client_id}:${client_secret}`
    - body 是 form data : Content-Type: application/x-www-form-urlencoded

7. App 前端调用 App 后端，App 后端再调用 Pig API 刷新 token
   
```http
POST /oauth2/token HTTP/1.1
Host: localhost:3000
Authorization: Basic YXBwOmFwcA==
Content-Type: application/x-www-form-urlencoded

grant_type=refresh_token
&refresh_token=-umOgmyURPa_6Jv1U169F3i7_Vt8pVdhexVeYd760iulr5FDx35Tce7Dr7J3D-tR_PfZMozrmR77IwRHysBvQe0-M1Bxlfjmpfjo6TN2bOz_N8sGj9KIrKz6TVGZoIX1
&scope=server
```