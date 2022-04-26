import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:news_app/modules/web_view/webview_screen.dart';

Widget BuildArticleItem(article, context) {
  String publishedAt = article['publishedAt'] , date = '' , time = '';
  for(int i = 0 ; i < publishedAt.length ; ++i){
    if(publishedAt[i] == 'T'){
      date = publishedAt.substring(0,i);
      time = publishedAt.substring(i+1 , publishedAt.length-1);
      break;
    }
  }
  return InkWell(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewScreen(article['url']),
          ));
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: NetworkImage('${article['urlToImage']}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Container(
              height: 120.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '${article['title']}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Text(
                    '${date + ' - ' + time}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget ArticleBuilder(list, context , {isSearch = false}) => ConditionalBuilder(
  condition: list.length > 0,
  builder: (context) => ListView.separated(
    physics: BouncingScrollPhysics(),
    itemBuilder: (context, index) => BuildArticleItem(list[index], context),
    separatorBuilder: (context, index) => const Divider(
      thickness: 2.5,
    ),
    itemCount: 10,
  ),
  fallback: (context) => isSearch ? Container() : Center(child: CircularProgressIndicator()),
    );
