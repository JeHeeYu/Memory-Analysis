import QtQuick 2.15

import "../Consts"

Text {
    id: root

    Fonts { id: fonts }

    font.family: fontLoader.name
    font.bold: true

    FontLoader {
        id: fontLoader
        source: fonts.pretendard
    }
}
