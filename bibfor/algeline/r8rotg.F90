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

subroutine r8rotg(da, db, dc, ds)
    implicit none
    real(kind=8) :: da, db, dc, ds
!        ROTATON PLANE  (METHODE DE GIVENS).
!-----------------------------------------------------------------------
! I/O : DA   : PREMIER ELEMENT DU VECTEUR.
!         OUT: R = (+/-)SQRT(DA**2 + DB**2) OVERWRITES DA.
!     : DB   : DEUXIEME ELEMENT DU VECTEUR.
!         OUT: ZDB OU Z EST DEFINI PAR
!                 DS        SI ABS(DA) .GT. ABS(DB)
!                 1.0D0/DC  SI ABS(DB) .GE. ABS(DA) ET DC .NE. 0.0D0
!                 1.0D0     SI DC .EQ. 0.0D0.
! OUT : DC   : COEFFICIENT DE ROTATION.
!     : DC   - COEFFICIENT DE ROTATION.
!-----------------------------------------------------------------------
    real(kind=8) :: r, u, v
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    if (abs(da) .gt. abs(db)) then
!                                       ABS(DA) .GT. ABS(DB)
        u = da + da
        v = db/u
!                     U ET R MEME SIGNE QUE DA
        r = sqrt(.25d0+v**2)*u
!                     DC EST POSITIF
        dc = da/r
        ds = v*(dc+dc)
        db = ds
        da = r
!                                   ABS(DA) .LE. ABS(DB)
    else
        if (db .ne. 0.0d0) then
            u = db + db
            v = da/u
!
!                   U ET R ONT MEME SIGNE QUE
!            DB (R EST IMMEDIATEMENT STOCKE DANS DA)
            da = sqrt(.25d0+v**2)*u
!                                  DS EST POSITIF
            ds = db/da
            dc = v*(ds+ds)
            if (dc .ne. 0.0d0) then
                db = 1.0d0/dc
            else
                db = 1.0d0
            endif
        else
!                                   DA = DB = 0.D0
            dc = 1.0d0
            ds = 0.0d0
            da = 0.0d0
            db = 0.0d0
        endif
    endif
end subroutine
