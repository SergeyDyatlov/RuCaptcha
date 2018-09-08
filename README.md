# RuCaptcha

Модуль написанный на Delphi для работы с сервисом RuCaptcha.com

## Реализованный функционал:
- Разгадывание обычной капчи (простая картинка)
- Разгадывание текстовой капчи (простой текст или вопрос)
- Разгадывание ReCaptcha V2 (капча от Google с галочкой)
- Отправка отчета о неверно разгаданной капче.
- Запрос баланса.

## Пример кода для простой капчи!
```pascal
SimpleCaptcha.CaptchaKey := 'Ваш API ключ';
Result := SimpleCaptcha.Recognize('Имя файла', CaptchaId);
  
// Если что то пошло не так, отправляем отчет о неверно разгаданной капче
// Аналогично для всех видов капч
SimpleCaptcha.SendReport(CaptchaId);
```

## Пример кода для текстовой капчи!
```pascal
TextCaptcha.CaptchaKey := 'Ваш API ключ';
Result := TextCaptcha.Recognize('Текст капчи', CaptchaId);
```

## Пример кода для ReCaptcha!
```pascal
ReCaptchaV2.CaptchaKey := 'Ваш API ключ';
Result := ReCaptchaV2.Recognize(GoogleKey, WebBrowser1.LocationURL, CaptchaId);
```
#### Внимание! Пример для ReCaptchaV2 немного усложнен, потому что нужно получить GoogleKey
Как найти GoogleKey описано тут https://rucaptcha.com/api-rucaptcha#solving_recaptchav2_new
В примере есть готовый вариант поиска GoogleKey и ввода полученной капчи в проверочное поле ввода

Вы можете создавать объекты сами, вместо использования глобальных 
переменных SimpleCaptcha, TextCaptcha, ReCaptchaV2.

#### По вопросам при предложениям можно обращаться в группе телеграм https://t.me/joinchat/CFH6xA8ihVkx0tHaNaT08g
