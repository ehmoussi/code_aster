! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

!
!
! because macros must be on a single line
! aslint: disable=C1509
#include "asterf_types.h"

#define ASSERT(cond) call assert(to_aster_logical(cond), TO_STRING(cond), __FILE__, __LINE__)

#define absent(a)   (.not.present(a))

! Exactly one argument is required
#define UN_PARMI2(a,b)      (present(a).neqv.present(b))
#define UN_PARMI3(a,b,c)    (present(a).neqv.present(b).neqv.present(c))
#define UN_PARMI4(a,b,c,d)  (present(a).neqv.present(b).neqv.present(c).neqv.present(d))

! At least one argument is required
#define AU_MOINS_UN2(a,b)       (present(a).or.present(b))
#define AU_MOINS_UN3(a,b,c)     (present(a).or.present(b).or.present(c))
#define AU_MOINS_UN4(a,b,c,d)   (present(a).or.present(b).or.present(c).or.present(d))

! At most one argument is required (== AU_PLUS_UN)
#define EXCLUS2(a,b)        (absent(a).or.absent(b))
#define EXCLUS3(a,b,c)      ((absent(a).or.(absent(b).and.absent(c))).and.(absent(b).or.(absent(a).and.absent(c))).and.(absent(c).or.(absent(a).and.absent(b))))
#define EXCLUS4(a,b,c,d)    ((absent(a).or.(absent(b).and.absent(c).and.absent(d))).and.(absent(b).or.(absent(a).and.absent(c).and.absent(d))).and.(absent(c).or.(absent(a).and.absent(b).and.absent(d))).and.(absent(d).or.(absent(a).and.absent(b).and.absent(c))))

! 0 or all arguments
#define ENSEMBLE2(a,b)      ((present(a).and.present(b)).or.(absent(a).and.absent(b)))
#define ENSEMBLE3(a,b,c)    ((present(a).and.present(b).and.present(c)).or.(absent(a).and.absent(b).and.absent(c)))
#define ENSEMBLE4(a,b,c,d)  ((present(a).and.present(b).and.present(c).and.present(d)).or.(absent(a).and.absent(b).and.absent(c).and.absent(d)))

interface
    subroutine assert(cond, str_cond, fname, line)
        aster_logical :: cond
        character(len=*) :: str_cond
        character(len=*) :: fname
        integer :: line
    end subroutine assert
end interface
