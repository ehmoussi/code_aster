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

subroutine nmevcv(sderro, fonact, nombcl)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/isfonc.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmeceb.h"
#include "asterfort/nmerge.h"
#include "asterfort/nmlecv.h"
    integer :: fonact(*)
    character(len=24) :: sderro
    character(len=4) :: nombcl
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! EVALUATION DE LA CONVERGENCE
!
! ----------------------------------------------------------------------
!
!
! IN  SDERRO : SD GESTION DES ERREURS
! IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
! IN  NOMBCL : NOM DE LA BOUCLE
!               'RESI' - BOUCLE SUR LES RESIDUS D'EQUILIBRE
!               'NEWT' - BOUCLE DE NEWTON
!               'FIXE' - BOUCLE DE POINT FIXE
!               'INST' - BOUCLE SUR LES PAS DE TEMPS
!               'CALC' - CALCUL
!
!
!
!
    aster_logical :: cveven
    integer :: ieven, zeven
    character(len=24) :: erreni, erreno, errfct
    integer :: jeeniv, jeenom, jeefct
    character(len=24) :: errinf
    integer :: jeinfo
    character(len=9) :: neven, teven
    character(len=24) :: feven
    aster_logical :: dv, cv, lfonc
    character(len=4) :: etabcl
    aster_logical :: cvresi, cvnewt, cvfixe, cvinst
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    etabcl = 'CONT'
!
! --- ACCES SD
!
    errinf = sderro(1:19)//'.INFO'
    erreno = sderro(1:19)//'.ENOM'
    erreni = sderro(1:19)//'.ENIV'
    errfct = sderro(1:19)//'.EFCT'
    call jeveuo(errinf, 'L', jeinfo)
    call jeveuo(erreno, 'L', jeenom)
    call jeveuo(erreni, 'L', jeeniv)
    call jeveuo(errfct, 'L', jeefct)
    zeven = zi(jeinfo-1+1)
!
    call nmlecv(sderro, 'RESI', cvresi)
    call nmlecv(sderro, 'NEWT', cvnewt)
    call nmlecv(sderro, 'FIXE', cvfixe)
    call nmlecv(sderro, 'INST', cvinst)
!
! --- EVALUATION DE LA CONVERGENCE
!
    cveven = .true.
    do 10 ieven = 1, zeven
        teven = zk16(jeeniv-1+ieven)(1:9)
        neven = zk16(jeenom-1+ieven)(1:9)
        feven = zk24(jeefct-1+ieven)
        dv = .false.
        cv = .true.
        if (teven .eq. 'CONV_'//nombcl) then
            if (feven .eq. ' ') then
                lfonc = .true.
            else
                lfonc = isfonc(fonact,feven)
            endif
            if (neven(1:4) .eq. 'DIVE') then
                call nmerge(sderro, neven, dv)
                dv = dv.and.lfonc
                cv = .true.
            else if (neven(1:4).eq.'CONV') then
                call nmerge(sderro, neven, cv)
                cv = cv.and.lfonc
                dv = .false.
            endif
            cveven = cveven.and.(.not.dv).and.cv
        endif
 10 end do
!
! --- RECUPERE CONVERGENCES PRECEDENTES
!
    if (nombcl .eq. 'NEWT') then
        cveven = cveven.and.cvresi
    endif
    if (nombcl .eq. 'FIXE') then
        cveven = cveven.and.cvnewt.and.cvresi
    endif
    if (nombcl .eq. 'INST') then
        cveven = cveven.and.cvfixe.and.cvnewt.and.cvresi
    endif
    if (nombcl .eq. 'CALC') then
        cveven = cveven.and.cvinst.and.cvfixe.and.cvnewt.and.cvresi
    endif
!
    if (cveven) etabcl = 'CONV'
!
! --- ENREGISTREMENT DE LA CONVERGENCE
!
    call nmeceb(sderro, nombcl, etabcl)
!
    call jedema()
end subroutine
