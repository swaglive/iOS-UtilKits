public class CornerButton: UIButton {
    private func setupView() {
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }

}
