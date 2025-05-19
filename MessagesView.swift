import SwiftUI
import Messages

struct MessagesView: View {
    let conversation: MSConversation
    @State private var templates: [String] = []
    @State private var templateNames: [String?] = []
    @State private var showEditor = false
    @State private var newTemplateText = ""
    @State private var newTemplateName = ""
    @State private var editingIndex: Int?

    var body: some View {
        VStack {
            Text("Templates")
                .font(.largeTitle).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .horizontal])

            if templates.isEmpty {
                Text("No Templates Yet")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(templates.indices, id: \.self) { index in
                        let text = templates[index]
                        let name = templateNames.indices.contains(index) ? templateNames[index] : nil

                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text((name?.isEmpty == false) ? name! : "Template")
                                    .font(.headline)
                                    .lineLimit(1)

                                Text(text)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 4)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            insertTemplate(text)
                        }
                        .contextMenu {
                            Button {
                                newTemplateText = text
                                newTemplateName = name ?? ""
                                editingIndex = index
                                showEditor = true
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }

                            Button(role: .destructive) {
                                templates.remove(at: index)
                                if templateNames.indices.contains(index) {
                                    templateNames.remove(at: index)
                                }
                                saveTemplates()
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }

            Button(action: {
                showEditor = true
                newTemplateText = ""
                newTemplateName = ""
                editingIndex = nil
            }) {
                Text("+ Create Template")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showEditor) {
            VStack {
                Text(editingIndex == nil ? "New Template" : "Edit Template")
                    .font(.headline)
                    .padding()

                TextField("Name Template (Optional)", text: $newTemplateName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextEditor(text: $newTemplateText)
                    .padding()
                    .border(Color.gray)

                Button(action: {
                    let trimmedText = newTemplateText.trimmingCharacters(in: .whitespacesAndNewlines)
                    let trimmedName = newTemplateName.trimmingCharacters(in: .whitespacesAndNewlines)
                    let finalName: String? = trimmedName.isEmpty ? nil : trimmedName
                    guard !trimmedText.isEmpty else { return }

                    if let index = editingIndex {
                        templates[index] = trimmedText
                        if templateNames.indices.contains(index) {
                            templateNames[index] = finalName
                        } else {
                            while templateNames.count < templates.count {
                                templateNames.append(nil)
                            }
                            templateNames[index] = finalName
                        }
                    } else if templates.count < 20 {
                        // Ensure both arrays stay in sync
                        templates.append(trimmedText)
                        while templateNames.count < templates.count - 1 {
                            templateNames.append(nil)
                        }
                        templateNames.append(finalName)
                    }

                    saveTemplates()
                    showEditor = false
                }) {
                    Text("Save Template")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                loadTemplates()
            }
        }
    }

    func insertTemplate(_ text: String) {
        conversation.insertText(text) { error in
            if let error = error {
                print("❌ Failed to insert text: \(error.localizedDescription)")
            } else {
                print("✅ Text inserted into iMessage input")
            }
        }
    }

    func saveTemplates() {
        let defaults = UserDefaults(suiteName: "group.com.zane.SaveTemplates")
        defaults?.set(templates, forKey: "savedTemplates")
        defaults?.set(templateNames, forKey: "savedTemplateNames")
    }

    func loadTemplates() {
        let defaults = UserDefaults(suiteName: "group.com.zane.SaveTemplates")
        templates = defaults?.stringArray(forKey: "savedTemplates") ?? []
        templateNames = defaults?.stringArray(forKey: "savedTemplateNames") ?? []
    }
}
