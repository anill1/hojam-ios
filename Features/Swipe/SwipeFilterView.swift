import SwiftUI

struct SwipeFilterView: View {
    @Binding var filter: SwipeFilter
    let onApply: () -> Void

    @State private var selectedFaculties: Set<String> = []

    private let faculties = ["Mühendislik", "İktisat", "Sanat", "Hukuk"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("filter_age_range")) {
                    VStack(alignment: .leading) {
                        Text("\(Int(filter.minAge)) - \(Int(filter.maxAge))")
                        RangeSlider(range: Binding(
                            get: { Double(filter.minAge) ... Double(filter.maxAge) },
                            set: { newValue in
                                filter.minAge = Int(newValue.lowerBound)
                                filter.maxAge = Int(newValue.upperBound)
                            }
                        ), bounds: 18 ... 35)
                    }
                }

                Section(header: Text("filter_faculty")) {
                    ForEach(faculties, id: \.self) { faculty in
                        Button {
                            if selectedFaculties.contains(faculty) {
                                selectedFaculties.remove(faculty)
                            } else {
                                selectedFaculties.insert(faculty)
                            }
                            filter.faculties = Array(selectedFaculties)
                        } label: {
                            HStack {
                                Text(faculty)
                                Spacer()
                                if selectedFaculties.contains(faculty) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        .accessibilityElement(children: .combine)
                    }
                }

                Section(header: Text("filter_options")) {
                    Toggle(isOn: Binding(
                        get: { filter.includeAnonymous },
                        set: { filter.includeAnonymous = $0 }
                    )) {
                        Text("filter_include_anonymous")
                    }
                }
            }
            .navigationTitle(Text("filters_button"))
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("apply_button") { onApply() }
                }
            }
            .onAppear {
                selectedFaculties = Set(filter.faculties)
            }
        }
    }
}

private struct RangeSlider: View {
    @Binding var range: ClosedRange<Double>
    let bounds: ClosedRange<Double>

    var body: some View {
        VStack {
            Slider(value: Binding(
                get: { range.lowerBound },
                set: { newValue in range = newValue ... max(newValue, range.upperBound) }
            ), in: bounds)
            Slider(value: Binding(
                get: { range.upperBound },
                set: { newValue in range = min(newValue, range.lowerBound) ... newValue }
            ), in: bounds)
        }
    }
}
