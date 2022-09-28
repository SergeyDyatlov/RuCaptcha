# RuCaptcha

Модуль написанный на Delphi для работы с сервисом RuCaptcha.com

## Реализованный функционал:
- Разгадывание обычной капчи (простая картинка)
- Разгадывание текстовой капчи (простой текст или вопрос)
- Разгадывание ReCaptcha V2 (капча от Google с галочкой)
- Разгадывание hCaptcha (подобие ReCaptcha)
- Отправка отчета о неверно разгаданной капче.
- Запрос баланса.

```pascal
FRuCaptcha := TRuCaptcha.Create;
```

## Пример кода для простой капчи!
```pascal
Captcha := TSimpleCaptcha.Create(FileName);
try
  FRuCaptcha.APIKey := 'Ваш API ключ';
  FRuCaptcha.SolveCaptcha(Captcha);
  Result := Captcha.Answer;
finally
  Captcha.Free;
end;
  
// Если что то пошло не так, отправляем отчет о неверно разгаданной капче
// Аналогично для всех видов капч
SimpleCaptcha.SendReport(CaptchaId);
```

## Пример кода для текстовой капчи!
```pascal
Captcha := TTextCaptcha.Create('Текст капчи');
try
  FRuCaptcha.APIKey := 'Ваш API ключ';
  FRuCaptcha.SolveCaptcha(Captcha);
  Result := Captcha.Answer;
finally
  Captcha.Free;
end;
```

## Пример кода для ReCaptcha!
```pascal
Captcha := TReCaptcha.Create(GoogleKey, PageURL);
try
  FRuCaptcha.APIKey := 'Ваш API ключ';
  FRuCaptcha.SolveCaptcha(Captcha);
  Result := Captcha.Answer;
finally
  Captcha.Free;
end;
```
#### Внимание! Пример для ReCaptchaV2 немного усложнен, потому что нужно получить GoogleKey
Как найти GoogleKey описано тут https://rucaptcha.com/api-rucaptcha#solving_recaptchav2_new
В примере есть готовый вариант поиска GoogleKey и ввода полученной капчи в проверочное поле ввода

#### По вопросам при предложениям можно обращаться в группе телеграм https://t.me/joinchat/CFH6xA8ihVkx0tHaNaT08g
