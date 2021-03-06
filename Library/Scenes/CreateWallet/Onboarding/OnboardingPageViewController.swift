//
//  Library
//
//  Created by 0 on 08.07.19.
//  Copyright © 2019 Zap. All rights reserved.
//

import Logger
import UIKit

protocol OnboardingPageViewControllerDelegate: class {
    func tutorialPageViewController(_ pageViewController: OnboardingPageViewController, didUpdatePageCount count: Int)
    func tutorialPageViewController(_ pageViewController: OnboardingPageViewController, didUpdatePageIndex index: Int)
    func tutorialPageViewController(_ pageViewController: OnboardingPageViewController, didUpdateButtonTitle buttonTitle: String)
}

final class OnboardingPageViewController: UIPageViewController {

    weak var containerDelegate: OnboardingPageViewControllerDelegate?

    var pages = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        view.backgroundColor = .clear

        if let firstViewController = pages.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }

        updatePageIndex()
    }

    func presentNext() -> Bool {
        guard
            let currentViewController = viewControllers?.first,
            let nextViewController = pageViewController(self, viewControllerAfter: currentViewController)
            else { return false }
        setViewControllers([nextViewController], direction: .forward, animated: true) { [weak self] _ in
            self?.updatePageIndex()
        }

        if
            let nextViewController = nextViewController as? OnboardingTextViewController,
            let buttonTitle = nextViewController.buttonTitle {
            containerDelegate?.tutorialPageViewController(self, didUpdateButtonTitle: buttonTitle)
        }

        return true
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        updatePageIndex()
    }

    private func updatePageIndex() {
        guard
            let currentViewController = viewControllers?.first,
            let index = pages.firstIndex(of: currentViewController)
            else { return }

        containerDelegate?.tutorialPageViewController(self, didUpdatePageIndex: index)
        containerDelegate?.tutorialPageViewController(self, didUpdatePageCount: pages.count)

        if
            let currentViewController = currentViewController as? OnboardingTextViewController,
            let buttonTitle = currentViewController.buttonTitle {
            containerDelegate?.tutorialPageViewController(self, didUpdateButtonTitle: buttonTitle)
        }
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0, pages.count > previousIndex else {
            return nil
        }

        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = pages.count

        guard orderedViewControllersCount != nextIndex, orderedViewControllersCount > nextIndex else {
            return nil
        }

        return pages[nextIndex]
    }
}
