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
SimpleCaptcha := TSimpleCaptcha.Create;
try
  SimpleCaptcha.CaptchaKey := 'Ваш API ключ';
  Result := SimpleCaptcha.Recognize('Имя файла', CaptchaId);
  
  // Вводим полученный результат в поле ввода
  // Если что то пошло не так, отправляем отчет о неверно разгаданной капче
  // Аналогично для всех видов капч
  SimpleCaptcha.SendReport(CaptchaId);
finally
  SimpleCaptcha.Free;
end;
```

## Пример кода для текстовой капчи!
```pascal
TextCaptcha := TTextCaptcha.Create;
try
  TextCaptcha.CaptchaKey := 'Ваш API ключ';
  Result := TextCaptcha.Recognize('Текст капчи', CaptchaId);
finally
  TextCaptcha.Free;
end;
```

## Пример кода для ReCaptcha!
```pascal
ReCaptcha := TReCaptchaV2.Create;
try
  ReCaptcha.CaptchaKey := edtCaptchaKey.Text;
  Result := ReCaptcha.Recognize(GoogleKey, WebBrowser1.LocationURL, CaptchaId);
finally
  ReCaptcha.Free;
end;
```
#### Внимание! Пример для ReCaptchaV2 немного усложнен, потому что нужно получить GoogleKey
Как найти GoogleKey описано тут https://rucaptcha.com/api-rucaptcha#solving_recaptchav2_new
В примере есть готовый вариант поиска GoogleKey и ввода полученной капчи в проверочное поле ввода
