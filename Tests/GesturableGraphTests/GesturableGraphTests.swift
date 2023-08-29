import XCTest
@testable import GesturableGraph

final class GesturableGraphTests: XCTestCase {
    // 해당 calibrationBottom 메서드는 calibrationTop과 구조가 비슷하므로
    // 문제될 요소인 음수에 관해서만 테스트
    func test_calibrationTop_요소가_비어있어도_동작되는지_확인() throws {
        let sample: [Double] = []
        let value: Double = 0.3
        let result = sample.calibrationTop(ofValue: value)

        XCTAssertNil(result)
    }

    func test_calibrationTop_요소가_다같아도_동작되는지_확인() throws {
        let sample: [Double] = [1, 1, 1, 1, 1]
        let value: Double = 0.3
        let result = sample.calibrationTop(ofValue: value)
        let expected: Double = 1.3

        XCTAssertEqual(result, expected)
    }

    func test_calibrationTop_모든_요소가_음수여도_동작되는지_확인() throws {
        let sample: [Double] = [-3, -33, -19, -17, -30]
        let value: Double = 0.3
        let result = sample.calibrationTop(ofValue: value)
        let expected: Double = 6

        XCTAssertEqual(result, expected)
    }

    func test_calibrationTop_모든_요소가_양수여도_동작되는지_확인() throws {
        let sample: [Double] = [3, 33, 19, 17, 30]
        let value: Double = 0.3
        let result = sample.calibrationTop(ofValue: value)
        let expected: Double = 42

        XCTAssertEqual(result, expected)
    }

    func test_calibrationTop_요소가_양수와음수_혼합이어도_동작되는지_확인() throws {
        let sample: [Double] = [-3, -33, 19, -17, 30]
        let value: Double = 0.3
        let result = sample.calibrationTop(ofValue: value)
        let expected: Double = 48.9

        XCTAssertEqual(result, expected)
    }

    func test_calibrationTop_매개변수가_음수여도_동작되는지_확인() throws {
        let sample: [Double] = [3, 33, 19, 17, 30]
        let value: Double = -0.3
        let result = sample.calibrationTop(ofValue: value)

        XCTAssertNil(result)
    }

    func test_calibrationTop_매개변수가_0이어도_동작되는지_확인() throws {
        let sample: [Double] = [3, 33, 19, 17, 30]
        let value: Double = 0
        let result = sample.calibrationTop(ofValue: value)
        let expected: Double = 33

        XCTAssertEqual(result, expected)
    }

    func test_calibrationBottom_모든_요소가_음수여도_동작되는지_확인() throws {
        let sample: [Double] = [-3, -33, -19, -17, -30]
        let value: Double = 0.3
        let result = sample.calibrationBottom(ofValue: value)
        let expected: Double = -42

        XCTAssertEqual(result, expected)
    }

    func test_calibrationBottom_요소가_양수와음수_혼합이어도_동작되는지_확인() throws {
        let sample: [Double] = [-3, -33, 19, -17, 30]
        let value: Double = 0.3
        let result = sample.calibrationBottom(ofValue: value)
        let expected: Double = -51.9

        XCTAssertEqual(result, expected)
    }
}
