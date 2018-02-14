# RuCaptcha

Модуль написанный на Delphi для работы с сервисом RuCaptcha.com

## Реализованный функционал:
- Разгадывание обычной капчи (простая картинка)
- Разгадывание текстовой капчи (простой текст или вопрос)
- Разгадывание ReCaptcha V2 (капча от Google с галочкой)
- Отправка отчета о неверно разгаданной капче.
- Запрос баланса.

## Пример кода для простой капчи!
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

## Пример кода для текстовой капчи!
TextCaptcha := TTextCaptcha.Create;
try
  TextCaptcha.CaptchaKey := 'Ваш API ключ';
  Result := TextCaptcha.Recognize('Текст капчи', CaptchaId);
finally
  TextCaptcha.Free;
end;


