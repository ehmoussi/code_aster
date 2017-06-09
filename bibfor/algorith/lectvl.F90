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

subroutine lectvl(zcmplx, itype, nbabs, inatur, ideas,&
                  nbmesu, labs, amin, apas, lvalc,&
                  lvalr)
!
!     LECTVL : LECTURE VALEURS SUR FICHIER FORMAT UNIVERSEL DATASET 58
!
!     IN : ZCMPLX : DONNEES COMPLEXE OU REELLE (BOOLEEN)
!     IN : ITYPE : MODE DE RANGEMENT DES DONNEES (EVEN/UNEVEN)
!     IN : NBABS : NOMBRE DE VALEURS CONTENUES DANS LE DATASET
!     IN : INATUR : NATURE DU CHAMP (SIMPLE/DOUBLE;REEL/COMPLEXE)
!     IN : IDEAS : NUMERO LOGIQUE DU FICHIER UNV
!     IN : NBMESU : NUMERO DE LA MESURE COURANTE
!     IN : LABS : ADRESSE DU VECTEUR DES ABSCISSES
!     IN : AMIN : ABSCISSE MIN
!     IN : APAS : PAS (ABSCISSE)
!     IN : LVALC : ADRESSE DU VECTEUR CONTENANT LES VALEURS COMPLEXES
!     IN : LVALR : ADRESSE DU VECTEUR CONTENANT LES VALEURS REELLES
!     ------------------------------------------------------------------
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
    aster_logical :: zcmplx
    integer :: itype, nbabs, inatur, ideas, nbmesu, labs, lvalc, lvalr
    real(kind=8) :: amin, apas
!
!
!
!
!
    integer :: i, nbli, rest, nbval, lig, incr, iabs
    integer :: icmpr, icmpi, icmpa
    real(kind=8) :: val(6)
!
!-----------------------------------------------------------------------
!
    call jemarq()
!
    iabs = 0
    if (zcmplx) then
! COMPLEX EVEN
        if (itype .eq. 1) then
            nbval = nbabs*2
            if (inatur .eq. 5) then
! COMPLEXE EVEN SIMPLE PRECISION
                nbli = int ( nbval / 6 )
                rest = nbval - ( nbli * 6 )
                do 151 lig = 1, nbli
                    read (ideas,'(6E13.5)',err=160) (val(i),i=1,6)
                    do 100 incr = 1, 3
                        iabs = iabs + 1
                        icmpr = (incr-1)*2 + 1
                        icmpi = (incr-1)*2 + 2
                        if (nbmesu .le. 1) then
                            zr(labs-1 + iabs) = amin + (iabs -1)*apas
                        endif
                        zc(lvalc-1 + (nbmesu-1)*nbabs + iabs) =&
                        dcmplx(val(icmpr),val(icmpi))
100                 continue
151             continue
                if (rest .ge. 1) then
                    read (ideas,'(6E13.5)',err=160) (val(i),i=1,rest)
                    do 152 incr = 1, int(rest/2)
                        iabs = iabs + 1
                        icmpr = (incr-1)*2 + 1
                        icmpi = (incr-1)*2 + 2
                        if (nbmesu .le. 1) then
                            zr(labs-1 + iabs) = amin + (iabs -1)*apas
                        endif
                        zc(lvalc-1 + (nbmesu-1)*nbabs + iabs) =&
                        dcmplx(val(icmpr),val(icmpi))
152                 continue
                endif
            else
! COMPLEXE EVEN DOUBLE PRECISION
                nbli = int ( nbval / 4 )
                rest = nbval - ( nbli * 4 )
                do 154 lig = 1, nbli
                    read (ideas,'(4E20.12)',err=160) (val(i),i=1,4)
                    do 153 incr = 1, 2
                        iabs = iabs + 1
                        icmpr = (incr-1)*2 + 1
                        icmpi = (incr-1)*2 + 2
                        if (nbmesu .le. 1) then
                            zr(labs-1 + iabs) = amin + (iabs -1)*apas
                        endif
                        zc(lvalc-1 + (nbmesu-1)*nbabs + iabs) =&
                        dcmplx(val(icmpr),val(icmpi))
153                 continue
154             continue
                if (rest .ge. 1) then
                    read (ideas,'(4E20.12)',err=160) (val(i),i=1,rest)
                    do 155 incr = 1, int(rest/2)
                        iabs = iabs + 1
                        icmpr = (incr-1)*2 + 1
                        icmpi = (incr-1)*2 + 2
                        if (nbmesu .le. 1) then
                            zr(labs-1 + iabs) = amin + (iabs -1)*apas
                        endif
                        zc(lvalc-1 + (nbmesu-1)*nbabs + iabs) =&
                        dcmplx(val(icmpr),val(icmpi))
155                 continue
                endif
            endif
        else
! COMPLEX UNEVEN
            nbval = nbabs*3
            if (inatur .eq. 5) then
! COMPLEXE UNEVEN SIMPLE PRECISION
                nbli = int ( nbval / 6 )
                rest = nbval - ( nbli * 6 )
                do 161 lig = 1, nbli
                    read (ideas,'(6E13.5)',err=160) (val(i),i=1,6)
                    do 162 incr = 1, 2
                        iabs = iabs + 1
                        icmpa = (incr-1)*3 + 1
                        icmpr = (incr-1)*3 + 2
                        icmpi = (incr-1)*3 + 3
                        if (nbmesu .le. 1) then
                            zr(labs-1 + iabs) = val(icmpa)
                        endif
                        zc(lvalc-1 + (nbmesu-1)*nbabs + iabs) =&
                        dcmplx(val(icmpr),val(icmpi))
162                 continue
161             continue
                if (rest .ge. 1) then
                    read (ideas,'(6E13.5)',err=160) (val(i),i=1,rest)
                    iabs = iabs + 1
                    if (nbmesu .le. 1) then
                        zr(labs-1 + iabs) = val(1)
                    endif
                    zc(lvalc-1 + (nbmesu-1)*nbabs + iabs) = dcmplx( val(2),val(3))
                endif
            else
! COMPLEX UNEVEN DOUBLE PRECISION
                nbli = int ( nbval / 3 )
                do 164 lig = 1, nbli
                    read (ideas,'(E13.5,2E20.12)',err=160) (val(i),i=&
                    1,3)
                    iabs = iabs + 1
                    icmpa = 1
                    icmpr = 2
                    icmpi = 3
                    if (nbmesu .le. 1) then
                        zr(labs-1 + iabs) = val(icmpa)
                    endif
                    zc(lvalc-1 + (nbmesu-1)*nbabs + iabs) = dcmplx( val(icmpr), val(icmpi) )
164             continue
            endif
        endif
!
    else
! REAL EVEN
        if (itype .eq. 1) then
            nbval = nbabs
            if (inatur .eq. 2) then
! REAL EVEN SIMPLE PRECISION
                nbli = int ( nbval / 6 )
                rest = nbval - ( nbli * 6 )
                do 171 lig = 1, nbli
                    read (ideas,'(6E13.5)',err=160) (val(i),i=1,6)
                    do 172 incr = 1, 6
                        iabs = iabs + 1
                        if (nbmesu .le. 1) then
                            zr(labs-1 + iabs) = amin + (iabs -1)*apas
                        endif
                        zr(lvalr-1 + (nbmesu-1)*nbabs + iabs) = val( incr)
172                 continue
171             continue
                if (rest .ge. 1) then
                    read (ideas,'(6E13.5)',err=160) (val(i),i=1,rest)
                    do 173 incr = 1, rest
                        iabs = iabs + 1
                        if (nbmesu .le. 1) then
                            zr(labs-1 + iabs) = amin + (iabs -1)*apas
                        endif
                        zr(lvalr-1 + (nbmesu-1)*nbabs + iabs) = val( incr)
173                 continue
                endif
            else
! REAL EVEN DOUBLE PRECISION
                nbli = int ( nbval / 4 )
                rest = nbval - ( nbli * 4 )
                do 184 lig = 1, nbli
                    read (ideas,'(4E20.12)',err=160) (val(i),i=1,4)
                    do 183 incr = 1, 4
                        iabs = iabs + 1
                        if (nbmesu .le. 1) then
                            zr(labs-1 + iabs) = amin + (iabs -1)*apas
                        endif
                        zr(lvalr-1 + (nbmesu-1)*nbabs + iabs) = val( incr)
183                 continue
184             continue
                if (rest .ge. 1) then
                    read (ideas,'(4E20.12)',err=160) (val(i),i=1,rest)
                    do 185 incr = 1, rest
                        iabs = iabs + 1
                        if (nbmesu .le. 1) then
                            zr(labs-1 + iabs) = amin + (iabs -1)*apas
                        endif
                        zr(lvalr-1 + (nbmesu-1)*nbabs + iabs) = val( incr)
185                 continue
                endif
            endif
        else
! REAL UNEVEN
            nbval = nbabs*2
            if (inatur .eq. 2) then
! REAL UNEVEN SIMPLE PRECISION
                nbli = int ( nbval / 6 )
                rest = nbval - ( nbli * 6 )
                do 191 lig = 1, nbli
                    read (ideas,'(6E13.5)',err=160) (val(i),i=1,6)
                    do 190 incr = 1, 3
                        iabs = iabs + 1
                        icmpa = (incr-1)*2 + 1
                        icmpr = (incr-1)*2 + 2
                        if (nbmesu .le. 1) then
                            zr(labs-1 + iabs) = val(icmpa)
                        endif
                        zr(lvalr-1 + (nbmesu-1)*nbabs + iabs) = val( icmpr)
190                 continue
191             continue
                if (rest .ge. 1) then
                    read (ideas,'(6E13.5)',err=160) (val(i),i=1,rest)
                    do 192 incr = 1, int(rest/2)
                        iabs = iabs + 1
                        icmpa = (incr-1)*2 + 1
                        icmpr = (incr-1)*2 + 2
                        if (nbmesu .le. 1) then
                            zr(labs-1 + iabs) = val(icmpa)
                        endif
                        zr(lvalr-1 + (nbmesu-1)*nbabs + iabs) = val( icmpr)
192                 continue
                endif
            else
! REAL UNEVEN DOUBLE PRECISION
                nbli = int ( nbval / 4 )
                rest = nbval - ( nbli * 4 )
                do 144 lig = 1, nbli
                    read (ideas,'(2(E13.5,E20.12))',err=160) (val(i),&
                    i=1,4)
                    do 143 incr = 1, 2
                        iabs = iabs + 1
                        icmpa = (incr-1)*2 + 1
                        icmpr = (incr-1)*2 + 2
                        if (nbmesu .le. 1) then
                            zr(labs-1 + iabs) = val(icmpa)
                        endif
                        zr(lvalr-1 + (nbmesu-1)*nbabs + iabs) = val( icmpr)
143                 continue
144             continue
                if (rest .ge. 1) then
                    read (ideas,'(2(E13.5,E20.12))',err=160) (val(i),&
                    i=1,rest)
                    do 145 incr = 1, int(rest/2)
                        iabs = iabs + 1
                        icmpa = (incr-1)*2 + 1
                        icmpr = (incr-1)*2 + 2
                        if (nbmesu .le. 1) then
                            zr(labs-1 + iabs) = val(icmpa)
                        endif
                        zr(lvalr-1 + (nbmesu-1)*nbabs + iabs) = val( icmpr)
145                 continue
                endif
            endif
        endif
    endif
! FIN LECTURE DU DATASET
    goto 9999
!
160 continue
! EN CAS D ERREUR DE LECTURE DU FICHIER UNV
    call utmess('F', 'ALGORITH5_5')
!
9999 continue
!
    call jedema()
!
end subroutine
