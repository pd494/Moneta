import Testing

@testable import Moneta

struct SurfaceTests {
    @Test(arguments: [Surface.calendar, .todos])
    func drawerAlwaysShowsTheOtherSurface(_ selected: Surface) {
        #expect(selected.opposite != selected)
        #expect(selected.opposite.opposite == selected)
    }
}
