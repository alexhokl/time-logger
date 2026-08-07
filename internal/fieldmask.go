package internal

import "strings"

// fieldMask decides which fields of an Update request the handler should
// apply.
//
// An empty mask is treated as "apply every field", which is what a CLI user
// doing `update project --name x` means without having to spell out a mask.
// A non-empty mask is authoritative, which is what a UI needs in order to
// clear a field: naming "color" while sending an empty colour is the only way
// to distinguish "set it to blank" from "leave it alone".
type fieldMask struct {
	fields map[string]struct{}
	all    bool
}

func newFieldMask(mask []string) fieldMask {
	if len(mask) == 0 {
		return fieldMask{all: true}
	}
	fields := make(map[string]struct{}, len(mask))
	for _, f := range mask {
		f = strings.ToLower(strings.TrimSpace(f))
		if f != "" {
			fields[f] = struct{}{}
		}
	}
	if len(fields) == 0 {
		return fieldMask{all: true}
	}
	return fieldMask{fields: fields}
}

// has reports whether the named field should be updated.
func (m fieldMask) has(name string) bool {
	if m.all {
		return true
	}
	_, ok := m.fields[name]
	return ok
}

// explicit reports whether the caller supplied a mask at all. Handlers use this
// where the "apply everything" default would be wrong, such as a field that
// should only change when named.
func (m fieldMask) explicit() bool { return !m.all }
