subroutine crnulg(numddl)
    implicit none
#include "asterf_config.h"
#include "asterf.h"
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/crnlgc.h"
#include "asterfort/crnlgn.h"
#include "asterfort/isdeco.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetc.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/juveca.h"
#include "asterfort/utimsd.h"
#include "asterc/loisem.h"
#include "asterfort/wkvect.h"
#include "asterfort/asmpi_info.h"
#include "asterc/asmpi_bcast_i.h"
#include "asterc/asmpi_send_i.h"
#include "asterc/asmpi_recv_i.h"
#include "asterc/asmpi_comm.h"
    character(len=14) :: numddl

#ifdef _USE_MPI
#include "mpif.h"
!
    integer :: rang, nbproc, jrefn, jdojoi, nbjoin, iaux, jgraco, nddll
    integer :: jmasqu, iproc1, iproc2, nbedge, posit, nmatch, icmp, ico2, nbcmp
    integer :: jtmp, dime, idprn1, idprn2, ntot, jordjo, num, ili, nunoel
    integer :: nec, l, numpro, jjoine, jjoinr, nbnoee, jaux, numno1, numno2, iec
    integer :: ncmpmx, iad, jcpnec, jencod, jenvoi1, lgenve1, lgenvr1, poscom, nddld
    integer :: nbddll, jnequ, jnugll, nddl, jenco2, deccmp, jcpne2
    integer :: jnbddl, decalp, jddlco, posddl, nuddl, inttmp, nbnoer, jrecep1
    integer :: decalm, nbjver, jprddl, jnujoi, cmpteu, lgrcor, jnbjoi, curpos
    integer :: jdeeq, jmlogl, nuno, ieq, numero_noeud, nb_ddl_envoi, nbddl
    integer :: ibid, jposdd, nddlg, jenvoi2, jrecep2
    integer :: lgenve2, lgenvr2, jnujoi1, jnujoi2
    integer(kind=4) :: un
    real(kind=8) :: dx, dy, dz
    character(len=24) :: nonulg
    integer(kind=4) :: iaux4, num4, numpr4, n4e, n4r
    mpi_int :: mrank, msize, mpicou
!
    character(len=4) :: chnbjo
    character(len=8) :: noma, k8bid, nomgdr
    character(len=24) :: nojoie, nojoir, nomtmp, noma24
!
!----------------------------------------------------------------------
    integer :: zzprno
!
!---- FONCTION D ACCES AUX ELEMENTS DES CHAMPS PRNO DES S.D. LIGREL
!     REPERTORIEES DANS LE CHAMP LILI DE NUME_DDL ET A LEURS ADRESSES
!     ZZPRNO(ILI,NUNOEL,1) = NUMERO DE L'EQUATION ASSOCIEES AU 1ER DDL
!                            DU NOEUD NUNOEL DANS LA NUMEROTATION LOCALE
!                            AU LIGREL ILI DE .LILI
!     ZZPRNO(ILI,NUNOEL,2) = NOMBRE DE DDL PORTES PAR LE NOEUD NUNOEL
!     ZZPRNO(ILI,NUNOEL,2+1) = 1ER CODE
!     ZZPRNO(ILI,NUNOEL,2+NEC) = NEC IEME CODE
!
    zzprno(ili,nunoel,l) = zi(idprn1-1+zi(idprn2+ili-1)+ (nunoel-1)* (nec+2)+l-1)
!
    call jemarq()
!
    call asmpi_comm('GET', mpicou)
    call asmpi_info(rank = mrank, size = msize)
    rang = to_aster_int(mrank)
    nbproc = to_aster_int(msize)
    ASSERT(nbproc.lt.9999)

!   Création de la numérotation
    call crnlgn(numddl)

!   Communication de la numérotation
    call crnlgc(numddl)

!   Suppression des objets temporaires
    call jedetc('V', '&&CRNULG', 1)
!
    call jedema()
#endif
!
end subroutine
