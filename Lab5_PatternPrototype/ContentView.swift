import SwiftUI

// Класс здания
class Building: Identifiable, Hashable {
    var id = UUID()
    var type: String?
    var floors: Int?
    var color: String?

    init(type: String) {
        self.type = type
    }

    func clone() -> Building {
        let clonedBuilding = Building(type: self.type ?? "")
        clonedBuilding.floors = self.floors
        clonedBuilding.color = self.color
        return clonedBuilding
    }

    static func == (lhs: Building, rhs: Building) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// Протокол для строителей зданий
protocol BuildingBuilder {
    func setFloors(_ number: Int) -> Self
    func setColor(_ color: String) -> Self
    func build() -> Building
}

// Конкретный строитель зданий
class ConcreteBuildingBuilder: BuildingBuilder {
    private var building: Building

    init(type: String) {
        self.building = Building(type: type)
    }

    func setFloors(_ number: Int) -> Self {
        building.floors = number
        return self
    }

    func setColor(_ color: String) -> Self {
        building.color = color
        return self
    }

    func build() -> Building {
        return self.building
    }
}

struct ContentView: View {
    @State private var selectedBuildingType = "Residential"
    @State private var floors = ""
    @State private var color = ""
    @State private var result: Building?
    @State private var copiedResult: [Building] = []
    @State private var numberOfCopies = 1

    var body: some View {
        VStack {
            Picker("Select Building Type", selection: $selectedBuildingType) {
                Text("Residential").tag("Residential")
                Text("Commercial").tag("Commercial")
            }
            .pickerStyle(.segmented)
            .padding()

            TextField("Enter Number of Floors", text: $floors)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Enter Building Color", text: $color)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Build") {
                buildBuilding()
            }
            .padding()

            Stepper("Number of Copies: \(numberOfCopies)", value: $numberOfCopies, in: 1...10)
                .padding()

            Button("Copy") {
                copyBuilding()
            }
            .padding()

            Button("Delete Copies") {
                deleteCopies()
            }
            .disabled(copiedResult.isEmpty)
            .padding()

            if let result = result {
                Text("Built \(result.type ?? "") building with \(result.floors ?? 0) floors and color \(result.color ?? "")")
                    .padding()
            }

            ForEach(copiedResult, id: \.self) { building in
                Text("Copied \(building.type ?? "") building with \(building.floors ?? 0) floors and color \(building.color ?? "")")
                    .padding()
            }
        }
        .padding()
    }

    private func buildBuilding() {
        let builder = ConcreteBuildingBuilder(type: selectedBuildingType)

        if let numberOfFloors = Int(floors) {
            builder.setFloors(numberOfFloors).setColor(color)
        }

        result = builder.build()
    }

    private func copyBuilding() {
        guard let result = result else { return }

        for _ in 0..<numberOfCopies {
            copiedResult.append(result.clone())
        }
    }

    private func deleteCopies() {
        copiedResult.removeAll()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
