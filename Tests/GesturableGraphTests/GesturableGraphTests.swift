import XCTest
@testable import GesturableGraph

final class GesturableGraphTests: XCTestCase {
    //MARK: - calibrationTop Test
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
        let expected: Double = 2.3

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

    //MARK: - calibrationBottom Test
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

    //MARK: - convertToPoints Test
    // elements에 맞게 설정된 graph
    private func graphForTest(elements: [Double]) -> Graph? {
        var graph = Graph(elements: elements)
        graph?.padding.top = 0
        graph?.padding.bottom = 0
        graph?.distribution = .equalSpacing

        return graph
    }

    func test_convertToPoints_요소가_양수일_때_값을_제대로_나오는지_확인() {
        let elements: [Double] = [2, 3, 4, 6, 8, 5, 1]
        let width: Double = Double(elements.count - 1) * 100
        let height: Double = (elements.max()! - elements.min()!) * 100
        guard let graph = graphForTest(elements: elements) else {
            XCTFail("Failed initialzied graph")
            return
        }

        let result = graph.points
        let expected: [Graph.Point] = [(0, 600), (100, 500), (200, 400), (300, 200), (400, 0), (500, 300), (600, 700)]
            .map { (x: $0.0 / width, y: $0.1 / height) }

        for (r, e) in zip(result, expected) {
            XCTAssertEqual(r.x, e.x)
            XCTAssertEqual(r.y, e.y)
        }
    }

    func test_convertToPoints_요소가_음수일_때_값을_제대로_나오는지_확인() {
        let elements: [Double] = [-2, -3, -4, -6, -8, -5, -1]
        let width: Double = Double(elements.count - 1) * 100
        let height: Double = (elements.max()! - elements.min()!) * 100
        guard let graph = graphForTest(elements: elements) else {
            XCTFail("Failed initialzied graph")
            return
        }

        let result = graph.points
        let expected: [Graph.Point] = [(0, 100), (100, 200), (200, 300), (300, 500), (400, 700), (500, 400), (600, 0)]
            .map { (x: $0.0 / width, y: $0.1 / height) }

        for (r, e) in zip(result, expected) {
            XCTAssertEqual(r.x, e.x)
            XCTAssertEqual(r.y, e.y)
        }
    }

    func test_convertToPoints_요소가_양수와음수_혼합이어도_제대로_나오는지_확인() {
        let elements: [Double] = [0, -3, 3, -3, 7, 0, 0]
        let width: Double = Double(elements.count - 1) * 100
        let height: Double = (elements.max()! - elements.min()!) * 100
        guard let graph = graphForTest(elements: elements) else {
            XCTFail("Failed initialzied graph")
            return
        }

        let result = graph.points
        let expected: [Graph.Point] = [(0, 700), (100, 1000), (200, 400), (300, 1000), (400, 0), (500, 700), (600, 700)]
            .map { (x: $0.0 / width, y: $0.1 / height) }

        for (r, e) in zip(result, expected) {
            XCTAssertEqual(r.x, e.x)
            XCTAssertEqual(r.y, e.y)
        }
    }

    func test_convertToPoints_distributiond이_aroundSpacing일_때_값이_제대로_나오는지_확인() {
        let elements: [Double] = [0, -3, 3, -3, 7]
        let width: Double = Double(elements.count - 1) * 100
        let height: Double = (elements.max()! - elements.min()!) * 100
        guard var graph = graphForTest(elements: elements) else {
            XCTFail("Failed initialzied graph")
            return
        }

        graph.distribution = .aroundSpacing

        let result = graph.points
        let expected: [Graph.Point] = [(40, 700), (120, 1000), (200, 400), (280, 1000), (360, 0)]
            .map { (x: $0.0 / width, y: $0.1 / height) }

        for (r, e) in zip(result, expected) {
            XCTAssertEqual(r.x, e.x)
            XCTAssertEqual(r.y, e.y)
        }
    }

    func test_convertToPoints_distributiond이_evenSpacing일_때_값이_제대로_나오는지_확인() {
        let elements: [Double] = [0, -3, 3, -3, 7, 1, -1, 3, 7]
        let width: Double = Double(elements.count - 1) * 100
        let height: Double = (elements.max()! - elements.min()!) * 100
        guard var graph = graphForTest(elements: elements) else {
            XCTFail("Failed initialzied graph")
            return
        }

        graph.distribution = .evenSpacing

        let result = graph.points
        let expected: [Graph.Point] = [(80, 700), (160, 1000), (240, 400), (320, 1000), (400, 0), (480, 600), (560, 800), (640, 400), (720, 0)]
            .map { (x: $0.0 / width, y: $0.1 / height) }

        for (r, e) in zip(result, expected) {
            XCTAssertEqual(r.x, e.x)
            XCTAssertEqual(r.y, e.y)
        }
    }

    func test_convertToPoints_verticalPadding의_top이_1일_때_값이_제대로_나오는지_확인() {
        let elements: [Double] = [1, 2, -1, 3]
        let width: Double = Double(elements.count - 1) * 100
        let height: Double = (elements.max()! - elements.min()!) * 100
        guard var graph = graphForTest(elements: elements) else {
            XCTFail("Failed initialzied graph")
            return
        }

        graph.padding.top = 1

        let result = graph.points
        let expected: [Graph.Point] = [(0, 300), (100, 250), (200, 400), (300, 200)]
            .map { (x: $0.0 / width, y: $0.1 / height) }

        for (r, e) in zip(result, expected) {
            XCTAssertEqual(r.x, e.x)
            XCTAssertEqual(r.y, e.y)
        }
    }

    func test_convertToPoints_verticalPadding의_bottom이_이분의일일_때_값이_제대로_나오는지_확인() {
        let elements: [Double] = [1.25, 2, -1]
        let width: Double = Double(elements.count - 1) * 100
        let height: Double = (elements.max()! - elements.min()!) * 100
        guard var graph = graphForTest(elements: elements) else {
            XCTFail("Failed initialzied graph")
            return
        }

        graph.padding.bottom = 0.5

        let result = graph.points
        let expected: [Graph.Point] = [(0, 50), (100, 0), (200, 200)]
            .map { (x: $0.0 / width, y: $0.1 / height) }

        for (r, e) in zip(result, expected) {
            XCTAssertEqual(r.x, e.x)
            XCTAssertEqual(r.y, e.y)
        }
    }
}
