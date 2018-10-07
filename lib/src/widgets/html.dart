import 'package:tinhte_html_widget/config.dart';
import 'package:tinhte_html_widget/html_widget.dart' as packaged;
import 'package:tinhte_html_widget/widget_factory.dart';

final wf = WidgetFactory(
  config: Config(
    baseUrl: Uri.parse('https://tinhte.vn'),
    parseElementCallback: (e) {
      if (e.className == 'bbCodeBlock bbCodeQuote') {
        return false;
      }

      return true;
    },
  )
);

class HtmlWidget extends packaged.HtmlWidget {
  HtmlWidget(String html)
    : super(html: html, widgetFactory: wf);
}