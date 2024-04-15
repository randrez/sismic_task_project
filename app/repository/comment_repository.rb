class CommentRepository

  def initialize
    @comment = Comment
  end

  def save(value, feature_id)
    @comment.create(comment: value, feature_id: feature_id)
  end

  def comments_by_feature_id(feature_id)
      @comment.by_feature_id(feature_id)
  end

end
