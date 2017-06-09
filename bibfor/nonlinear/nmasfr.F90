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

subroutine nmasfr(ds_contact, matass)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/cfdisd.h"
#include "asterfort/cfdisl.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/infbav.h"
#include "asterfort/infdbg.h"
#include "asterfort/infmue.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mtcmbl.h"
#include "asterfort/sdmpic.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
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
! In  ds_contact       : datastructure for contact management
! I/O MATASS  : IN  MATR_ASSE TANGENTE
!               OUT MATR_ASSE TANGENTE + MATRICE CONTACT/FROTTEMENT
!                  (EVENTUELLE)
!
! ----------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=14) :: numedf
    integer :: nbliac
    character(len=19) :: matrcf
    character(len=24) :: limat(2)
    real(kind=8) :: coefmu(2)
    character(len=1) :: typcst(2)
    aster_logical :: lmodim
    character(len=8) ::  kmpic1
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('CONTACT', ifm, niv)
!
! --- INITIALISATIONS
!
    lmodim = cfdisl(ds_contact%sdcont_defi,'MODI_MATR_GLOB')
    nbliac = cfdisd(ds_contact%sdcont_solv,'NBLIAC')
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
    matrcf = ds_contact%sdcont_solv(1:14)//'.MATR'
    limat(1) = matass
    limat(2) = matrcf
    coefmu(1) = 1.d0
    coefmu(2) = 1.d0
    typcst(1) = 'R'
    typcst(2) = 'R'
!
! - Get numbering object for discrete friction methods
! 
    numedf = ds_contact%nume_dof_frot
    call detrsd('NUME_DDL', numedf)
!
    call infmue()
    call dismoi('MPI_COMPLET', matass, 'MATR_ASSE', repk=kmpic1)
    if (kmpic1 .eq. 'NON') then 
        call sdmpic('MATR_ASSE', matass)
    endif
    
    call dismoi('MPI_COMPLET', matrcf, 'MATR_ASSE', repk=kmpic1)
    if (kmpic1 .eq. 'NON') then 
        call sdmpic('MATR_ASSE', matrcf)
    endif
    
    call mtcmbl(2, typcst, coefmu, limat, matass,&
                ' ', numedf, 'ELIM1')
    call infbav()
    call dismoi('NOM_NUME_DDL', matrcf, 'MATR_ASSE', repk=numedf)
    call detrsd('MATR_ASSE', matrcf)
    call detrsd('NUME_DDL', numedf)
!
999 continue
!
    call jedema()
!
end subroutine
