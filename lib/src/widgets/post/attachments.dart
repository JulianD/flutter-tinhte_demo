part of '../posts.dart';

const kAttachmentSize = 100.0;

class _PostAttachmentsWidget extends StatelessWidget {
  final List<Attachment> attachments;

  _PostAttachmentsWidget(this.attachments);

  @override
  Widget build(BuildContext context) => SizedBox(
        height: kAttachmentSize,
        child: ListView.separated(
          itemBuilder: (context, i) => _buildAttachment(attachments[i]),
          itemCount: attachments.length,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, i) =>
              const Padding(padding: const EdgeInsets.only(left: 10.0)),
        ),
      );

  Widget _buildAttachment(Attachment attachment) => CachedNetworkImage(
        imageUrl: attachment.links.thumbnail,
        fit: BoxFit.cover,
        height: kAttachmentSize,
        width: kAttachmentSize,
      );

  static _PostAttachmentsWidget forPost(Post post) {
    final attachments = post.attachments
        ?.where((attachment) => !attachment.attachmentIsInserted)
        ?.toList();
    if (attachments?.isNotEmpty != true) return null;

    return _PostAttachmentsWidget(attachments);
  }
}