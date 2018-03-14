! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine nmasun(resocu, matass)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/cudisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/exisd.h"
#include "asterfort/infbav.h"
#include "asterfort/infdbg.h"
#include "asterfort/infmue.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mtcmbl.h"
    character(len=24) :: resocu
    character(len=19) :: matass
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES DISCRETES - ALGORITHME)
!
! CREATION DE LA MATRICE DE CONTACT/FROTTEMENT
!
! ----------------------------------------------------------------------
!
!
! IN  DEFICO  : SD DE DEFINITION DU CONTACT
! IN  RESOCO  : SD CONTACT
! I/O MATASS  : IN  MATR_ASSE TANGENTE
!               OUT MATR_ASSE TANGENTE + MATRICE CONTACT/FROTTEMENT
!                  (EVENTUELLE)
!
!
!
!
    integer :: ifm, niv
    character(len=14) :: numedf, nume_ddl
    integer :: nbliac, iret
    character(len=19) :: matrcf
    character(len=24) :: limat(2)
    real(kind=8) :: coefmu(2)
    character(len=1) :: typcst(2)
    aster_logical :: lmodim
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('CONTACT', ifm, niv)
!
! --- INITIALISATIONS
!
!   A modifier dans une version plus aboutie
    lmodim = .true.
    nbliac = cudisd(resocu,'NBLIAC')
    if (nbliac .eq. 0) then
        goto 999
    endif
    if (.not.lmodim) then
        goto 999
    endif
!
    if (niv .ge. 2) then
        write (ifm,*) '<CONTACT> AJOUT MATRICE CONTACT/FROTTEMENT'
    endif
!
    matrcf = resocu(1:14)//'.MATR'
    limat(1) = matass
    limat(2) = matrcf
    coefmu(1) = 1.d0
    coefmu(2) = 1.d0
    typcst(1) = 'R'
    typcst(2) = 'R'
!
!   On donne un nom quelconque pour le nouveau NUME_DDL
    nume_ddl = '&&NMASUN.NUME'
    call exisd('NUME_DDL', nume_ddl, iret)
    if(iret==1) then
        call detrsd('NUME_DDL', nume_ddl)
    endif
    call infmue()
    call mtcmbl(2, typcst, coefmu, limat, matass,&
                ' ', nume_ddl, 'ELIM1')
    call infbav()
    call dismoi('NOM_NUME_DDL', matrcf, 'MATR_ASSE', repk=numedf)
    call detrsd('MATR_ASSE', matrcf)
    if(numedf.ne.nume_ddl) then
        call detrsd('NUME_DDL', numedf)
    endif
!
999 continue
!
    call jedema()
!
end subroutine
